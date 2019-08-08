CREATE PROC  [ERP].[Usp_Ins_Propiedad]
@IdPropiedad	INT OUT,
@IdUnidadMedida INT ,
@Nombre			VARCHAR(50),
@FlagBorrador	BIT,
@UsuarioRegistro VARCHAR(250)
AS
BEGIN
			INSERT INTO [Maestro].[Propiedad](IdUnidadMedida,Nombre,FlagBorrador,Flag,UsuarioRegistro,FechaRegistro) VALUES (@IdUnidadMedida,@Nombre,@FlagBorrador,1,@UsuarioRegistro,DATEADD(HOUR, 3, GETDATE()))

			SET @IdPropiedad = (SELECT CAST(SCOPE_IDENTITY() AS int));

END
