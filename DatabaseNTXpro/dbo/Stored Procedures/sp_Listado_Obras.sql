-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Listado_Obras 
	-- Add the parameters for the stored procedure here
	@IdEmpresa int,
	@Estado int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 If @Estado = 3 
		begin
                SELECT Proyecto.ID, Proyecto.Numero as CODIGO, Proyecto.Nombre AS DESCRIPCION, Entidad.Nombre AS CLIENTE
                FROM (ERP.Proyecto INNER JOIN ERP.Cliente ON (Proyecto.IdEmpresa = Cliente.IdEmpresa) AND (Proyecto.IDCliente = Cliente.ID)) 
                INNER JOIN ERP.Entidad ON Cliente.IdEntidad = Entidad.ID
                WHERE Proyecto.IdEmpresa=@IdEmpresa and Proyecto.Flag=1 and Proyecto.FlagBorrador=0
                ORDER BY Proyecto.Numero ASC
		end
     Else
           begin
			    SELECT Proyecto.ID, Proyecto.Numero as CODIGO, Proyecto.Nombre AS DESCRIPCION, Entidad.Nombre AS CLIENTE
                FROM (ERP.Proyecto INNER JOIN ERP.Cliente ON (Proyecto.IdEmpresa = Cliente.IdEmpresa) and  (Proyecto.IDCliente = Cliente.ID)) 
                INNER JOIN ERP.Entidad ON Cliente.IdEntidad = Entidad.ID
                WHERE Proyecto.IdEmpresa = @IdEmpresa And Proyecto.FlagCierre = @Estado and Proyecto.Flag=1 and Proyecto.FlagBorrador=0
                ORDER BY Proyecto.Numero ASC
            End 
END