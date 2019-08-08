
CREATE PROC [ERP].[Usp_Upd_Vale_Importar]
@IdVale INT,
@IdEstadoVale INT
AS
BEGIN
		UPDATE ERP.Vale SET IdValeEstado = @IdEstadoVale WHERE ID = @IdVale

END
