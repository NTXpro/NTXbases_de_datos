-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_BuscaUsuario
	-- Add the parameters for the stored procedure here
	@usuario varchar (100),
	@clave varchar(20) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID from Seguridad.Usuario where Correo = @usuario and Clave= @clave
END