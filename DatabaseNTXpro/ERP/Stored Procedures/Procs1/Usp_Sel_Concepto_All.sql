CREATE PROCEDURE [ERP].[Usp_Sel_Concepto_All] --1
@IdEmpresa INT
AS
BEGIN
	SELECT 
		C.ID,
		TC.ID AS IdTipoConcepto,
	    TC.Nombre AS NombreTipoConcepto,
		CL.ID AS IdClase,
		CL.Nombre AS NombreClase,
		ITD.CodigoSunat,
		C.Nombre,
		C.Abreviatura,
		C.FlagSiemprePlanilla,
		C.FlagEstructuraPlanilla,
		C.Orden
	FROM [ERP].[Concepto] C
	INNER JOIN [Maestro].[TipoConcepto] TC ON C.IdTipoConcepto = TC.ID
	INNER JOIN [Maestro].[Clase] CL ON C.IdClase = CL.ID
	INNER JOIN [PLAME].[T22IngresoTributoDescuento] ITD ON C.IdIngresoTributoDescuento = ITD.ID
    WHERE
	
    C.FlagBorrador = 0
END

