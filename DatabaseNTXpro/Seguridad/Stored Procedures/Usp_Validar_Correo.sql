
--select COUNT(ID)  from Seguridad.Usuario where Correo = 'michael_12_2006@g.com'  AND FlagBorrador = 0 and ID != 0

CREATE PROC [Seguridad].[Usp_Validar_Correo] --0,'michael_12_2006@g.com'
@IdUsuario INT,
@Correo VARCHAR(50)
AS
BEGIN
	
	DECLARE @RESULT INT = (SELECT COUNT(ID) 
							FROM Seguridad.Usuario 
							WHERE Correo = @Correo AND FlagBorrador = 0 
							and ID != @IdUsuario
						   )

	SELECT @RESULT
END