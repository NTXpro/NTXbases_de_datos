-- =============================================
-- Author:		Omar Rodriguez
-- Create date: 2019-03-01
-- Description:	Listado de Tipos de Estados Trabajador, para validacion de jubilados en calculo planilla
-- =============================================
CREATE PROCEDURE ERP.Usp_Sel_TipoEstadoTrabajador
AS
BEGIN
  SELECT tet.Id, tet.Nombre FROM Maestro.TipoEstadoTrabajador tet
END