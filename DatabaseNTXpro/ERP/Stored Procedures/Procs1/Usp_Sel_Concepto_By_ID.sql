CREATE PROCEDURE [ERP].[Usp_Sel_Concepto_By_ID]
@ID INT
AS
BEGIN
	SELECT 
		C.ID,
	    TC.ID AS IdTipoConcepto,
	    TC.Nombre AS NombreTipoConcepto,
		CL.ID AS IdClase,
		CL.Nombre AS NombreClase,
		CL.Codigo AS CodigoClase,
		ITD.ID AS IdIngresoTributoDescuento,
		ITD.CodigoSunat,
		CONCAT(ITD.CodigoSunat, ' - ', ITD.Nombre) AS NombreIngresoTributoDescuento,
		C.Orden,
		C.Nombre,
		C.Abreviatura,
		C.PorDefecto,
		C.FlagSiemprePlanilla,
		C.FlagEstructuraPlanilla,
		C.UsuarioRegistro,
		C.FechaRegistro,
		C.UsuarioModifico,
		C.FechaModificado,
		C.UsuarioElimino,
		C.FechaEliminado,
		C.UsuarioActivo,
		C.FechaActivacion,
		C.FlagBorrador,
		C.Flag
	FROM [ERP].[Concepto] C
	LEFT JOIN [Maestro].[TipoConcepto] TC ON C.IdTipoConcepto = TC.ID
	LEFT JOIN [Maestro].[Clase] CL ON C.IdClase = CL.ID
	LEFT JOIN [PLAME].[T22IngresoTributoDescuento] ITD ON C.IdIngresoTributoDescuento = ITD.ID
    WHERE
    C.ID = @ID
END
