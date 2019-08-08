CREATE PROC [ERP].[Usp_Upd_UndiadMedida_Borrador]
@IdUnidadMedida	INT,
@Nombre			VARCHAR(50),
@CodigoSunat	VARCHAR(50)
AS
BEGIN
		UPDATE [PLE].[T6UnidadMedida] SET Nombre= @Nombre , CodigoSunat = @CodigoSunat  WHERE ID=@IdUnidadMedida
END
