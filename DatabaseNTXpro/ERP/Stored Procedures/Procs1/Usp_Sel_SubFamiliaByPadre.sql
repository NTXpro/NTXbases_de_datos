CREATE PROC [ERP].[Usp_Sel_SubFamiliaByPadre]
@IdFamiliaPadre INT,
@IdEmpresa INT
AS
BEGIN

		SELECT FA.ID,
			   FA.Nombre,
			   FA.IdFamiliaPadre,
			   FA.IdEmpresa,
			   FA.FlagSistema
		FROM ERP.Familia FA
		WHERE FA.IdEmpresa = @IdEmpresa AND FA.IdFamiliaPadre = @IdFamiliaPadre
END
