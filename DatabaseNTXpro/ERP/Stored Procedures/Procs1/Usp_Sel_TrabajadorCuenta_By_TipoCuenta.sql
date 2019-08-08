
create PROC [ERP].[Usp_Sel_TrabajadorCuenta_By_TipoCuenta]
@IdTrabajador INT,
@IdTipoCuenta INT
AS
BEGIN
SELECT TC.ID
      ,TC.IdEmpresa
      ,TC.IdTrabajador
      ,TC.IdBanco
      ,TC.IdTipoCuenta
      ,TC.Fecha
      ,TC.NumeroCuenta
      ,TC.NumeroCuentaInterbancario
      ,TC.FechaRegistro
      ,TC.UsuarioRegistro
      ,TC.FechaModificado
      ,TC.UsuarioModifico
	  ,E.Nombre NombreBanco
  FROM ERP.TrabajadorCuenta TC
  INNER JOIN PLE.T3Banco B ON B.ID = TC.IdBanco
  INNER JOIN ERP.Entidad E ON E.ID = B.IdEntidad
  WHERE TC.IdTrabajador = @IdTrabajador AND TC.IdTipoCuenta = @IdTipoCuenta
END
