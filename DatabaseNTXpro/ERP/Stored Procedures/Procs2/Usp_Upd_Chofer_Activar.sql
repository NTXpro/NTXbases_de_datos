
CREATE PROC [ERP].[Usp_Upd_Chofer_Activar]
@IdChofer	INT
AS
BEGIN
	UPDATE ERP.Chofer SET Flag = 1 ,FechaEliminado = NULL WHERE ID = @IdChofer
END
