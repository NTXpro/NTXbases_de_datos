
CREATE PROCEDURE [ERP].[Usp_Upd_Establecimiento_By_Id]
@IdEstablecimiento		INT,
@IdTipoEstablecimiento	INT,
@IdVia					INT,
@IdZona					INT,
@IdUbigeo				INT,
@NombreEstablecimiento	VARCHAR(50),
@Direccion				VARCHAR(250),
@NombreVia				VARCHAR(50),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@NombreZona				VARCHAR(50),
@Sector					VARCHAR(20),
@Grupo					VARCHAR(20),
@Manzana				VARCHAR(20),
@Lote					VARCHAR(20),
@Kilometro				VARCHAR(20),
@Referencia				VARCHAR(50),
@Telefono				VARCHAR(50),
@Celular				VARCHAR(50),
@FlagBorrador			BIT,
@Flag					BIT,
@UsuarioModifico		VARCHAR(50),
@FechaModificado		DATETIME
AS
BEGIN

	UPDATE ERP.Establecimiento SET	IdTipoEstablecimiento = @IdTipoEstablecimiento,
									IdVia = @IdVia,
									IdZona = @IdZona,
									IdUbigeo = @IdUbigeo,
									Nombre = @NombreEstablecimiento,
									Sector = @Sector,
									Grupo = @Grupo,
									Manzana = @Manzana,
									Lote = @Lote,
									Kilometro = @Kilometro,
									Direccion = @Direccion,
									ViaNombre = @NombreVia,
									ViaNumero = @NumeroVia,
									Interior = @Interior,
									ZonaNombre = @NombreZona,
									Referencia = @Referencia,
									Telefono = @Telefono,
									Celular = @Celular,
									FlagBorrador = @FlagBorrador,
									Flag = @Flag,
									UsuarioModifico = @UsuarioModifico,
									FechaModificado = @FechaModificado
	WHERE ID = @IdEstablecimiento

END
