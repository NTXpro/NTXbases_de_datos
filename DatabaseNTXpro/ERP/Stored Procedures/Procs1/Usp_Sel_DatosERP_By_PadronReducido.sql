
CREATE proc [ERP].[Usp_Sel_DatosERP_By_PadronReducido]
@CodigoUbigeo VARCHAR(6),
@CodigoVia VARCHAR(5),
@CodigoZona VARCHAR(5),
@CondicionSunat VARCHAR(50),
@EstadoContribuyente VARCHAR(50)
AS
BEGIN
	DECLARE @CodigoSunat VARCHAR(6)= (SELECT CodigoSunat FROM [PLAME].[T7Ubigeo] WHERE CodigoSunat = @CodigoUbigeo);

	IF @CodigoSunat IS NULL 
	BEGIN
		SELECT 
		(SELECT [Maestro].[ObtenerIdCondicionSunat_By_Nombre](@CondicionSunat)) IdCondicionSunat,
		(SELECT [Maestro].[ObtenerIdEstadoContribuyente_By_Nombre](@EstadoContribuyente)) IdEstadoContribuyente,
		(SELECT [PLAME].[ObtenerIdZona_By_Abreviatura](@CodigoZona)) IdZona,
		(SELECT [PLAME].[ObtenerIdVia_By_Abreviatura](@CodigoVia)) IdVia,
		CAST(0 AS INT) IdDepartamento,
		CAST(0 AS INT) IdProvincia,
		CAST(0 AS INT) IdDistrito
	END
	ELSE	
	BEGIN
		SELECT 
		(SELECT [Maestro].[ObtenerIdCondicionSunat_By_Nombre](@CondicionSunat)) IdCondicionSunat,
		(SELECT [Maestro].[ObtenerIdEstadoContribuyente_By_Nombre](@EstadoContribuyente)) IdEstadoContribuyente,
		(SELECT [PLAME].[ObtenerIdZona_By_Abreviatura](@CodigoZona)) IdZona,
		(SELECT [PLAME].[ObtenerIdVia_By_Abreviatura](@CodigoVia)) IdVia,
		(SELECT [PLAME].[ObtenerIdDepartamento_By_Distrito](U.ID)) IdDepartamento,
		(SELECT [PLAME].[ObtenerIdProvincia_By_Distrito](U.ID)) IdProvincia,
		U.ID IdDistrito
		FROM [PLAME].[T7Ubigeo] U
		WHERE U.CodigoSunat = @CodigoUbigeo
	END

	
END



