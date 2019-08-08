CREATE PROC [ERP].[Usp_Sel_Cliente]
@idEmpresa INT
AS
BEGIN
					   SELECT   C.ID,
								EN.Nombre AS NombreCompleto,
								C.FechaRegistro,
								P.Nombre,
								P.ApellidoPaterno,
								P.ApellidoMaterno,
								ETD.IdTipoDocumento,
								ETD.NumeroDocumento,
								TD.Abreviatura AS NombreTipoDocumento,
								C.FlagClienteBoleta,
								EST.ID IdEstablecimiento,
								EST.Direccion,
								C.IdEntidad
						FROM ERP.Cliente C
						INNER JOIN ERP.Entidad EN
						ON EN.ID = C.IdEntidad
						LEFT JOIN ERP.Persona P
						ON P.IdEntidad = EN.ID
						INNER JOIN ERP.EntidadTipoDocumento ETD
						ON ETD.IdEntidad = EN.ID
						INNER JOIN PLE.T2TipoDocumento TD
						ON TD.ID = ETD.IdTipoDocumento
						INNER JOIN ERP.Establecimiento EST
						ON EST.IdEntidad = EN.ID AND EST.IdTipoEstablecimiento = 1
						WHERE C.Flag = 1 AND C.FlagBorrador = 0 AND IdEmpresa = @idEmpresa
						order by NombreCompleto

END