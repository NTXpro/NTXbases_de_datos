CREATE PROC [ERP].[Usp_Sel_Valor_Parametro_By_Abreviatura_Fecha]
@IdEmpresa INT,
@Abreviatura VARCHAR(10),
@Fecha DATETIME
AS
BEGIN
	SELECT [ERP].[ObtenerValorParametroByAbreviaturaFecha](@IdEmpresa, @Abreviatura, @Fecha)
END
