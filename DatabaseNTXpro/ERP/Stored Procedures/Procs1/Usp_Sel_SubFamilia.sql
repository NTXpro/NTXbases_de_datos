CREATE PROC [ERP].[Usp_Sel_SubFamilia]
@IdEmpresa INT
AS
BEGIN

		SELECT FA.ID,
			   FA.Nombre,
			   FA.IdFamiliaPadre,
			   FA.IdEmpresa,
			   FA.FlagSistema
		FROM ERP.Familia FA
		WHERE FA.IdEmpresa = @IdEmpresa 
END
