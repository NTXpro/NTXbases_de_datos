CREATE PROC [ERP].[Usp_Sel_LetraCobrar_By_ID]
@ID INT
AS
BEGIN
SELECT top 1 LC.ID
      ,LC.IdCliente
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
	  ,E.Nombre NombreCliente
	   ,CASE WHEN (SELECT COUNT(AAP.ID) FROM ERP.AplicacionAnticipoCobrar AAP WHERE AAP.IdCuentaCobrar = LCP.IdCuentaCobrar) > 0 THEN
		CAST(1 AS BIT)
	  ELSE
		CAST(0 AS BIT)
	  END AS FlagAnticipo,
	  LC.IdMoneda,
	  M.Nombre NombreMoneda
  FROM ERP.LetraCobrar LC
  INNER JOIN ERP.LetraCobrarCuentaCobrar LCP ON LCP.IdLetraCobrar = LC.ID
  INNER JOIN ERP.Cliente C ON C.ID = LC.IdCliente
  INNER JOIN ERP.Entidad E ON E.ID = C.IdEntidad
  INNER JOIN Maestro.Moneda M ON M.ID = LC.IdMoneda
  WHERE LC.ID = @ID

END