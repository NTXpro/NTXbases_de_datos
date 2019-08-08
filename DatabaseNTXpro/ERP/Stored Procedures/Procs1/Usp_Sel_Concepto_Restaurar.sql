CREATE PROCEDURE [ERP].[Usp_Sel_Concepto_Restaurar]
@IdEmpresa INT
AS
BEGIN
	SELECT 
		C.ID,
	    TC.Nombre AS NombreTipoConcepto,
		CL.Nombre AS NombreClase,
		ITD.CodigoSunat,
		C.Nombre,
		C.Abreviatura,
		C.FlagSiemprePlanilla,
		C.FlagEstructuraPlanilla
	FROM [ERP].[Concepto] C
	LEFT JOIN [Maestro].[TipoConcepto] TC ON C.IdTipoConcepto = TC.ID
	LEFT JOIN [Maestro].[Clase] CL ON C.IdClase = CL.ID
	LEFT JOIN [PLAME].[T22IngresoTributoDescuento] ITD ON C.IdIngresoTributoDescuento = ITD.ID
    WHERE
    C.Flag = 0 
END
