
CREATE PROC [ERP].[Usp_Upd_Chofer_Desactivar]
@IdChofer	INT
AS
BEGIN
	UPDATE ERP.Chofer SET Flag = 0 , FechaEliminado = DATEADD(HOUR, 3, GETDATE()) WHERE ID = @IdChofer
END
