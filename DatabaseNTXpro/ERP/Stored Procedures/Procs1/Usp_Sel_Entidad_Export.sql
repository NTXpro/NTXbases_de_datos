
create PROC [ERP].[Usp_Sel_Entidad_Export] --1,1,10,'DESC','NombreCompleto',0
@Flag BIT
AS
BEGIN
		SELECT
			E.ID,
			E.Nombre "NombreCompleto",
			TD.Abreviatura "NombreTipoDocumento",
			ETD.NumeroDocumento,
			TP.Nombre "TipoPersona"
		FROM ERP.Entidad E
		INNER JOIN ERP.EntidadTipoDocumento ETD
			ON ETD.IdEntidad = E.ID
		INNER JOIN [PLE].[T2TipoDocumento] TD
			ON TD.ID = ETD.IdTipoDocumento
		INNER JOIN Maestro.TipoPersona TP
			ON TP.ID = E.IdTipoPersona
		WHERE E.Flag = @Flag AND E.FlagBorrador = 0
END

