
CREATE PROCEDURE [ERP].[Usp_Upd_Establecimiento]
@IdEntidad				INT,
@IdTipoEstablecimiento	INT,
@IdVia					INT,
@IdZona					INT,
@IdPais					INT,
@IdUbigeo				INT,
@NombreEstablecimiento	VARCHAR(250),
@Direccion				VARCHAR(250),
@NombreVia				VARCHAR(250),
@NumeroVia				VARCHAR(4),
@Interior				VARCHAR(4),
@NombreZona				VARCHAR(250),
@Referencia				VARCHAR(250),
@Sector					VARCHAR(20),
@Grupo					VARCHAR(20),
@Manzana				VARCHAR(20),
@Lote					VARCHAR(20),
@Kilometro				VARCHAR(20),
@FlagBorrador			BIT,
@Flag					BIT
AS
BEGIN

	UPDATE ERP.Establecimiento SET	IdTipoEstablecimiento = @IdTipoEstablecimiento,
									IdVia = @IdVia,
									IdZona = @IdZona,
									IdPais = @IdPais,
									IdUbigeo = @IdUbigeo,
									Nombre = @NombreEstablecimiento,
									Direccion = @Direccion,
									ViaNombre = @NombreVia,
									ViaNumero = @NumeroVia,
									Interior = @Interior,
									ZonaNombre = @NombreZona,
									Referencia = @Referencia,
									Sector = @Sector,
									Grupo = @Grupo,
									Manzana = @Manzana,
									Lote = @Lote,
									Kilometro = @Kilometro,
									FlagBorrador = @FlagBorrador,
									Flag = @Flag
	WHERE IdEntidad = @IdEntidad AND IdTipoEstablecimiento = @IdTipoEstablecimiento

END
