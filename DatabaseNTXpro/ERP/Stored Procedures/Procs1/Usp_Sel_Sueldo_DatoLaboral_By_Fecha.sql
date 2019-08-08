CREATE PROC [ERP].[Usp_Sel_Sueldo_DatoLaboral_By_Fecha]
@IdDatoLaboral INT,
@Fecha DATETIME
AS
BEGIN
	SELECT [ERP].[ObtenerSueldoDatoLaboralByFecha](@IdDatoLaboral, @Fecha)
END
