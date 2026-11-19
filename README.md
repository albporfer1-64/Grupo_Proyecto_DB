# Base de Datos - ONG Atachiarare

Sistema de gestión de base de datos relacional (MySQL) para la **ONG Atachiarare**. El modelo está diseñado para administrar de forma integral las distintas misiones educativas y sociales en Togo (Apadrinamiento, Becados y Escuela de Oficios), la plantilla de trabajadores y empleados, la relación con los benefactores y la trazabilidad económica de los proyectos.

## 📁 Estructura de Archivos del Proyecto

* `oficial_crear_tables_4.sql`: Definición del esquema relacional, claves primarias/foráneas, claves alternativas y restricciones declarativas (`CHECK` y `ENUM`).
* `oficial_insertar_tables.sql`: Carga inicial de datos maestros e históricos ordenados por niveles de dependencia.
* `triggers.sql`: Implementación de disparadores (`TRIGGERS`) para garantizar las reglas de negocio complejas que cruzan múltiples tablas.
* `comprobacion_crear_tables.sql`: Batería de pruebas negativas diseñada para validar que las restricciones y disparadores bloquean correctamente operaciones no permitidas.

---

## ⚙️ Orden de Ejecución

Para desplegar la base de datos correctamente y evitar conflictos con datos históricos (como antiguos apadrinados que ya cumplieron la mayoría de edad), ejecuta los scripts en el siguiente orden estricto:

1. **Creación de estructura:**
   Ejecuta `oficial_crear_tables_4.sql` para limpiar el entorno y generar todas las tablas y restricciones nativas.
2. **Población de datos:**
   Ejecuta `oficial_insertar_tables.sql` para insertar el conjunto inicial de personas, misiones, contratos, notas y movimientos económicos.
3. **Activación de reglas de negocio:**
   Ejecuta `triggers.sql` para instalar los disparadores en la base de datos. Al hacerlo en este paso, se permite la carga limpia del histórico y se protegen todas las operaciones futuras.
4. **Validación del sistema (Opcional):**
   Ejecuta `comprobacion_crear_tables.sql`. Todas las consultas de este archivo están diseñadas para fallar; si MySQL devuelve los errores controlados (`Error 1644`, `Error 3819`, `Error 1265`), el sistema está funcionando correctamente.

---

## 🚀 Funcionalidades y Características Técnicas

* **Modelo Jerárquico y Solapamiento Controlado:** Centralización de datos personales en la tabla `Persona`, permitiendo especializaciones disjuntas para las misiones (`Escuela_Oficios`, `Becados`, `Apadrinamiento`) y roles compatibles para el personal (`Empleado`, `Trabajador`, `Benefactor`).
* **Arcos Exclusivos Nativos:** Uso de restricciones `CHECK` en tablas como `ContratoTrabajador`, `SueldoPagado` y `ContieneAProyecto` para garantizar que un registro esté asociado a una y solo una misión simultáneamente.
* **Control Académico y Financiero:** Seguimiento de calificaciones (acotadas entre 0 y 10 mediante `CHECK`), control de cuotas de apadrinamiento, pago de nóminas y desglose de costes por actividades dentro de cada proyecto.
* **Gestión de Marketing:** Registro de comunicaciones con benefactores mediante estados predefinidos (`ENUM`) y franjas horarias de contacto.

---

## 🛡️ Reglas de Negocio (Triggers)

Para aquellas validaciones que requieren consultar el estado de otras tablas o evaluar rangos de fechas activos, el sistema cuenta con los siguientes disparadores en `triggers.sql`:

* **RN01 — Límite de edad en Apadrinamiento (`TRG_RN01_Apadrinado_Edad`):**
  Impide dar de alta a un nuevo apadrinado activo si la persona ya tiene 18 años o más en la fecha de registro.
* **RN02 — Unicidad de contrato vigente (`TRG_RN02_ContratoPadrino_INS` / `UPD`):**
  Garantiza que un niño apadrinado no pueda tener más de un contrato de apadrinamiento activo (con `fecha_fin` nula o futura) de forma simultánea.
* **RN04 — Exclusividad de ayuda económica (`TRG_RN04_*`):**
  Evita la duplicidad de recursos y conflictos de roles mediante 9 disparadores (`BEFORE INSERT` y `BEFORE UPDATE`):
  * Una persona con una ayuda activa (Apadrinado, Becado o Estudiante de Oficios) **no puede** iniciar ni reactivar otra misión distinta al mismo tiempo.
  * Una persona que recibe ayuda económica activa **no puede** ser dada de alta como `Trabajador`, `Empleado` ni `Benefactor` mientras dicha ayuda siga vigente.