CREATE PROC [ERP].[Usp_Sel_LetraPagar_By_ID]
@ID INT
AS
BEGIN
SELECT TOP 1 LC.ID
      ,LC.IdProveedor
      ,LC.IdEmpresa
      ,LC.FechaEmision
      ,LC.FechaVencimiento
	  ,LC.Serie
      ,LC.Numero
      ,LC.DiasVencimiento
      ,LC.Porcentaje
      ,LC.Monto
      ,LC.UsuarioRegistro
      ,LC.UsuarioModifico
      ,LC.FechaRegistro
      ,LC.FechaModificado
	  ,E.Nombre NombreProveedor
	  ,CASE WHEN (SELECT COUNT(AAP.ID) FROM ERP.AplicacionAnticipoPagar AAP WHERE AAP.IdCuentaPagar = LCP.IdCuentaPagar AND Flag = 1) > 0 THEN
		CAST(1 AS BIT)
	  ELSE
		CAST(0 AS BIT)
	  END AS FlagAnticipo,
	  LC.IdMoneda,
	  M.Nombre NombreMoneda
  FROM ERP.LetraPagar LC
  INNER JOIN ERP.LetraPagarCuentaPagar LCP ON LCP.IdLetraPagar = LC.ID
  INNER JOIN ERP.Proveedor P ON P.ID = LC.IdProveedor
  INNER JOIN ERP.Entidad E ON E.ID = P.IdEntidad
  INNER JOIN Maestro.Moneda M ON M.ID = LC.IdMoneda
  WHERE LC.ID = @ID

END