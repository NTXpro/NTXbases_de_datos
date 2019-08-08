-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_Empresa_x_Usuario
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ERP.Empresa.Id, ERP.Entidad.Nombre
	FROM (ERP.EmpresaUsuario INNER JOIN ERP.Empresa ON ERP.EmpresaUsuario.IdEmpresa = ERP.Empresa.ID) 
	INNER JOIN ERP.Entidad ON ERP.Empresa.IdEntidad = ERP.Entidad.ID
	WHERE (((ERP.EmpresaUsuario.IdUsuario)=@id));

END