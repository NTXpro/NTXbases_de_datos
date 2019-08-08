CREATE procedure [ERP].[Usp_Ins_Puesto]


@IdPuesto INT OUT ,
@IdOcupacion INT,
@Nombre				VARCHAR(50),

@UsuarioRegistro	VARCHAR(250),
@FlagBorrador		BIT
AS

BEGIN

	
			INSERT INTO [Maestro].[Puesto]( IdOcupacion, Nombre,FlagSunat, FlagBorrador,Flag,UsuarioRegistro,FechaRegistro,UsuarioModifico,FechaModificado)
			VALUES( @IdOcupacion,  @Nombre, 0, @FlagBorrador, 1, @UsuarioRegistro, DATEADD(HOUR, 3, GETDATE()), @UsuarioRegistro, DATEADD(HOUR, 3, GETDATE()));

	
	
			SET @IdPuesto= (SELECT CAST(SCOPE_IDENTITY()AS INT));
	
END