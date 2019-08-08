-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Busca_Obras_Detallado]
	-- Add the parameters for the stored procedure here
	@idEmpresa int,
	@Desde varchar(10),
	@Hasta varchar(10),
	@Estado int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
if   @Estado= 3   
	begin
		select id, Numero, Nombre, IdEmpresa, idMoneda,FlagCierre,iif(fechaCierre is null, GETDATE(),fechaCierre)as fechaCierre_
		 from erp.proyecto
				where IdEmpresa=@idEmpresa and Numero between  @Desde and @Hasta and 
						flag =1 and flagborrador=0 
				  order by FlagCierre asc, numero asc
	end
else
	begin 
		select id, Numero, Nombre, IdEmpresa, idMoneda,FlagCierre,iif(fechaCierre is null, GETDATE(),fechaCierre)as fechaCierre_ 
		from erp.proyecto
				where IdEmpresa=@idEmpresa and Numero between  @Desde and @Hasta and 
						FlagCierre=@Estado and flag =1 and flagborrador=0
				  order by FlagCierre asc,numero asc
	end
END