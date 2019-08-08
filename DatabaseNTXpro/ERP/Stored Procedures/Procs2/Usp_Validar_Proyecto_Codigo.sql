CREATE PROC [ERP].[Usp_Validar_Proyecto_Codigo]
@IdProyecto INT,
@IdEmpresa INT,
@Codigo VARCHAR(10)
AS
BEGIN

		SELECT COUNT(*)
		FROM ERP.Proyecto PR
		WHERE PR.ID !=@IdProyecto AND PR.IdEmpresa = @IdEmpresa AND PR.Flag = 1 AND PR.FlagBorrador = 0 AND Numero = @Codigo

END
