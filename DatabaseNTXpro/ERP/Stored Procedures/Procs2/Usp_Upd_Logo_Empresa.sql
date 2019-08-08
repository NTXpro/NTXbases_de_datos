CREATE PROC ERP.Usp_Upd_Logo_Empresa
@IdEmpresa INT,
@NombreImagen VARCHAR(250),
@Imagen	VARBINARY(MAX)
AS
BEGIN
	UPDATE ERP.Empresa SET Imagen = @Imagen, NombreImagen = @NombreImagen
	WHERE ID = @IdEmpresa
END