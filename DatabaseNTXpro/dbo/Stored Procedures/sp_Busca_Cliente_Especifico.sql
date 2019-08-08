-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Busca_Cliente_Especifico
	-- Add the parameters for the stored procedure here
	@iCodigoEmpresa int,
	@idCliente int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 SELECT Entidad.Nombre  
                FROM ERP.Cliente 
               INNER JOIN ERP.Entidad ON Cliente.IdEntidad = Entidad.ID 
                 WHERE Cliente.IdEmpresa=@iCodigoEmpresa and Cliente.ID=@idCliente
				 ORDER BY Entidad.Nombre
END