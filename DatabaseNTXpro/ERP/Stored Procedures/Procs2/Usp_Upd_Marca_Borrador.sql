CREATE PROC [ERP].[Usp_Upd_Marca_Borrador]
@IdMarca	INT,
@Nombre			VARCHAR(50)

AS
BEGIN
		UPDATE Maestro.Marca SET Nombre= @Nombre   WHERE ID=@IdMarca
END
