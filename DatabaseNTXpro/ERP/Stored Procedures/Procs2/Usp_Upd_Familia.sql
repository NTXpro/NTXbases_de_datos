
CREATE PROC ERP.Usp_Upd_Familia
@IdFamilia INT,
@Nombre VARCHAR(250),
@IdEmpresa INT
AS
BEGIN

	UPDATE ERP.Familia SET Nombre = @Nombre  WHERE ID = @IdFamilia AND IdEmpresa = @IdEmpresa

END
