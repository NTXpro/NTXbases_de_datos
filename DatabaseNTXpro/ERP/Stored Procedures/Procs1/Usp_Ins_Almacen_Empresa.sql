
CREATE PROC [ERP].[Usp_Ins_Almacen_Empresa]
@IdEmpresa INT
AS
BEGIN
	
	DECLARE @IdEstablecimiento INT = (SELECT TOP 1 ES.ID
									  FROM ERP.Empresa E INNER JOIN ERP.Entidad EN
										ON EN.ID = E.IdEntidad
									  INNER JOIN ERP.Establecimiento ES
										ON ES.IdEntidad = EN.ID
										 WHERE E.ID = @IdEmpresa)

	
	INSERT INTO ERP.Almacen(Nombre, IdEmpresa, IdEstablecimiento, FechaRegistro, FlagBorrador, Flag, FlagPrincipal)
	VALUES('ALMACEN PRINCIPAL', @IdEmpresa, @IdEstablecimiento, GETDATE(), 0, 1, 1)  
 
END

