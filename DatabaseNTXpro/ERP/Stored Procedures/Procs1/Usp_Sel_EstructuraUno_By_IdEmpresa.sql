CREATE PROCEDURE [ERP].[Usp_Sel_EstructuraUno_By_IdEmpresa] --4,1
@IdEmpresa INT,
@Tipo INT
AS
BEGIN
	SELECT 
		EU.ID AS IdEstructuraUno,
		EU.Nombre AS NombreUno,
		EU.IdEmpresa,
		ED.ID AS IdEstructuraDos,
		ED.Nombre AS NombreDos,
		------------------------
		ET.ID AS IdEstructuraTres,
		ET.Nombre AS NombreTres,
		ET.Orden
	FROM [ERP].[EstructuraUno] EU
	INNER JOIN [ERP].[EstructuraDos] ED ON EU.ID = ED.IdEstructuraUno
	LEFT JOIN [ERP].[EstructuraTres] ET ON ED.ID = ET.IdEstructuraDos
	WHERE 
	EU.IdEmpresa = @IdEmpresa AND
	EU.Flag = 1 AND
	ED.Flag = 1 AND
	EU.Tipo = @Tipo
	ORDER BY
	EU.ID,
	ED.ID,
	ET.Orden
END
