CREATE PROC [ERP].[Usp_Upd_Existencia_Borrador]
@IdExistencia	INT,
@Nombre			VARCHAR(50),
@CodigoSunat	VARCHAR(100)
AS
BEGIN
		UPDATE [PLE].[T5Existencia] SET Nombre= @Nombre , CodigoSunat = @CodigoSunat  WHERE ID=@IdExistencia
END