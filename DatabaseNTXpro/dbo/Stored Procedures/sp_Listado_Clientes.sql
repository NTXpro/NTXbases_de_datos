-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Listado_Clientes]
	-- Add the parameters for the stored procedure here
	@idempresa int,
	@busqueda varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	If @busqueda =''
		begin
               SELECT Cliente.ID, Entidad.Nombre, EntidadTipoDocumento.NumeroDocumento AS RUC 
                FROM ERP.Cliente 
                INNER JOIN ERP.Entidad ON Cliente.IdEntidad = Entidad.ID 
				INNER JOIN ERP.EntidadTipoDocumento ON ERP.Entidad.ID=ERP.EntidadTipoDocumento.IdEntidad
                WHERE Cliente.IdEmpresa= @idempresa
                ORDER BY Entidad.Nombre
		end
    Else
         begin
                SELECT Cliente.ID, Entidad.Nombre, EntidadTipoDocumento.NumeroDocumento AS RUC  
                FROM ERP.Cliente
                INNER JOIN ERP.Entidad ON Cliente.IdEntidad = Entidad.ID 
				INNER JOIN ERP.EntidadTipoDocumento ON ERP.Entidad.ID=ERP.EntidadTipoDocumento.IdEntidad
                WHERE Cliente.IdEmpresa= @idempresa and Entidad.Nombre like @busqueda
                ORDER BY Entidad.Nombre
		end

END