CREATE PROC ERP.Usp_Sel_Gratificacion_By_ID
@ID INT
AS
BEGIN
	SELECT ID
      ,IdEmpresa
      ,IdAnio
      ,IdFecha
      ,FechaInicio
      ,FechaFin
      ,UsuarioRegistro
      ,FechaRegistro
      ,UsuarioModifico
      ,FechaModificado
  FROM ERP.Gratificacion
  where ID = @ID
END
