
CREATE PROC [ERP].[Usp_Sel_Parametro_By_ID]
@ID int
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
			A.Nombre										Anio,
			PE.IdMes										IdMes,
			M.Nombre										Mes,
			PA.UsuarioRegistro,
			PA.UsuarioModifico,
			PA.FechaRegistro,
			PA.FechaModificado
	FROM [ERP].[Parametro] PA
	INNER JOIN [ERP].[Periodo] PE
	ON PE.ID=PA.IdPeriodo
	INNER JOIN [Maestro].[TipoParametro] TPA
	ON TPA.ID=PA.IdTipoParametro
	INNER JOIN Maestro.Anio A
	ON A.ID = PE.IdAnio
	INNER JOIN Maestro.Mes M
	ON M.ID = PE.IdMes
	WHERE PA.ID = @ID
END
