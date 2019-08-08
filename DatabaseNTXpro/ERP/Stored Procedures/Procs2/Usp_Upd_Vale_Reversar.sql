
CREATE PROC [ERP].[Usp_Upd_Vale_Reversar]
@IdVale INT
AS
BEGIN
	UPDATE ERP.Vale SET IdValeEstado = 1 WHERE ID = @IdVale
END
