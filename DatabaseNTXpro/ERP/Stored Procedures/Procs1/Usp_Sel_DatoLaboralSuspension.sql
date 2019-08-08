create PROC [ERP].[Usp_Sel_DatoLaboralSuspension]
@IdDatoLaboral INT,
@IdEmpresa INT
AS
BEGIN
		SELECT SU.* ,TS.*
		FROM ERP.DatoLaboralSuspension SU
		INNER JOIN PLAME.T21TipoSuspension TS ON TS.ID = SU.IdTipoSuspension
		INNER JOIN ERP.DatoLaboral DL ON DL.ID = SU.IdDatoLaboral
		INNER JOIN ERP.Empresa EM ON EM.ID = SU.IdEmpresa
		WHERE SU.IdDatoLaboral = @IdDatoLaboral AND EM.ID = @IdEmpresa

END
