CREATE PROC ERP.Usp_Del_Familia
@IdFamilia INT,
@IdEmpresa INT
AS
BEGIN

	DELETE ERP.Familia WHERE ID = @IdFamilia AND IdEmpresa = @IdEmpresa
END
