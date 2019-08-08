
	create PROC [ERP].[Usp_Sel_Parametro_By_Abreviatura]
@Abreviatura VARCHAR(5)
AS
BEGIN

	SELECT	PA.ID											ID,
			PE.ID											IdPeriodo,
			TPA.ID											IdTipoParametro,
			PA.Nombre										NombreParametro,
			PA.Abreviatura									Abreviatura,
			PA.Valor										Valor,
			TPA.Nombre										NombreTipoParametro,
			PE.IdAnio										IdAnio,
			PE.IdMes										IdMes,
			PA.UsuarioRegistro,
			PA.UsuarioModifico,
			PA.FechaRegistro,
			PA.FechaModificado
	FROM [ERP].[Parametro] PA
	INNER JOIN [ERP].[Periodo] PE
	ON PE.ID=PA.IdPeriodo
	INNER JOIN [Maestro].[TipoParametro] TPA
	ON TPA.ID=PA.IdTipoParametro
	WHERE PA.Abreviatura = @Abreviatura
END
