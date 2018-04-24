declare @CodPais CHAR(2)
set @CodPais = 'PE'

---------VAR OBJETIVO-----------
drop table #cosechaestablecidas
select CodPais, AnioCampana, PkEbelista, CodComportamientoRolling into #cosechaestablecidas
from  [DWH_ANALITICO].DBO.DWH_FSTAEBECAM
where CodPais = @CodPais and AnioCampana = '201713' and CodComportamientoRolling in (2, 3,4,5,6,7) 


drop table #vtas3camp
select a.PkEbelista, a.AnioCampana, sum(RealVtaMNNeto/Realtcpromedio) as vta
into #vtas3camp
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a 
inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  
on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais and a.AnioCampana = b.AnioCampana
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
where a.CodPais = @CodPais 
and RealVtaMNNeto > 0
and a.PkEbelista in (select PkEbelista from #cosechaestablecidas)
and CodTipoProfit = '01'
and a.AnioCampana in ('201711', '201712', '201713', '201715')
and a.AnioCampana = a.AnioCampanaRef
group by a.PkEbelista, a.AnioCampana
order by PkEBelista, AnioCampana

SELECT * FROM #vtas3camp

--select PkEBELISTA, count(1)
--from #vtas3camp
--group by PkEbelista
--having count(1) = 4
--order by count(1) desc
----15605

drop table #vtasTrasp
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713,[201715] as v201715  into #vtasTrasp
FROM
(    SELECT * FROM #vtas3camp
) AS SourceTable PIVOT(AVG([vta]) FOR [AnioCampana] IN([201711],
[201712], [201713], [201715] )) AS PivotTable


drop table ventascons1										
select * into ventascons1 from #vtasTrasp where 
v201711 is not null and
v201712 is not null
and  v201713 is not null and  v201715 is not null


									
select * from ventascons1


drop table #ventascons
select *,
case
when (v201713 + v201711 + v201712)/3 > v201715
and (v201715/v201713 -1 )*100 < -10 then 1
else 0 
end as [Target] into #ventascons
from ventascons1

select * from #ventascons



---------VAR 2-----------
drop table #pedidos_ult_18camp
select b.PkEBELISTA, sum(FlagPasoPedido) as Pedidos_ult_18camp into #pedidos_ult_18camp
from #ventascons a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b on a.PkEbelista = b.PkEbelista
where b.AnioCampana in ('201713','201712','201711','201710','201709','201708','201707','201706','201705',
'201704','201703','201702','201701','201618','201617','201616','201615','201614') and CodPais = @CodPais
group by b.Pkebelista 

drop table #var2
select b.*, a.Pedidos_ult_18camp into #var2
from #pedidos_ult_18camp a inner join #ventascons b on a.PKEbelista =b.PKEbelista

select * from #var2

---------VAR 3-----------


drop table #PDPañoanterior
select a.PkEbelista, sum(RealVtaMNNeto/Realtcpromedio) as vta, count(distinct a.AnioCampana) as CampañaPasoPedido, sum(RealVtaMNNeto/Realtcpromedio)/count(distinct a.AnioCampana) as PDP into #PDPañoanterior
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  
on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais and a.AnioCampana = b.AnioCampana
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
inner join #ventascons d on a.PKEbelista =d.PKEbelista
where a.CodPais = @CodPais 
and CodTipoProfit = '01'
and a.AnioCampana in ('201701','201618','201617','201616','201615','201614','201613')
and a.AnioCampana = a.AnioCampanaRef
and RealVtaMNNeto > 0
group by a.PkEbelista
order by PkEBelista

select * from #PDPañoanterior

drop table #decilañoanterior
select PkEbelista, Ntile (10) over (order by PDP desc) as [Decil], PDP as PDPAñoAnterior into #decilañoanterior
FROM #PDPañoanterior

drop table #decil
select a.*, b.PDPAñoAnterior, b.Decil into #decil
from #ventascons a  left join #decilañoanterior b on a.PKEbelista = b.pkebelista

drop table #var3
select b.*, a.Decil as DecilAñoAnterior, a.PDPAñoAnterior into #var3
from #decil a inner join #var2 b on b.PKEbelista = a.PKEbelista

select * from #var3

---------VAR 4-----------
drop table #PDPCampanterior
select a.PkEbelista, sum(RealVtaMNNeto/Realtcpromedio) as vta, count(distinct a.AnioCampana) as CampañaPasoPedido, 
sum(RealVtaMNNeto/Realtcpromedio)/count(distinct a.AnioCampana) as PDP into #PDPCampanterior
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  
on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais and a.AnioCampana = b.AnioCampana
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
inner join #ventascons d on a.PKEbelista =d.PKEbelista
where a.CodPais = @CodPais and CodTipoProfit = '01' and a.AnioCampana = a.AnioCampanaRef and RealVtaMNNeto > 0	
and a.AnioCampana = '201713'
group by a.PkEbelista
order by PkEBelista

SELECT * FROM #PDPCampanterior

drop table #decilcampanterior
select PkEbelista, Ntile (10) over (order by PDP desc) as [Decil], PDP as PDPCampAnterior into #DecilCampAnterior
FROM #PDPCampanterior

drop table #cf_decil
select a.*, b.PDPCampAnterior, b.Decil into #cf_decil
from #ventascons a  left join #decilcampanterior b on a.PKEbelista = b.pkebelista

drop table #var4
select b.*, a.Decil as DecilCampAnterior, a.PDPCampAnterior into #var4
from #cf_decil a inner join #var3 b on b.PKEbelista = a.PKEbelista

-------HACER VAR CON DECIL DE ULTIMAS 7 CAMPAÑAS------
drop table #PDP3Camps
select a.PkEbelista, sum(RealVtaMNNeto/Realtcpromedio) as vta, count(distinct a.AnioCampana) as CampañaPasoPedido, 
sum(RealVtaMNNeto/Realtcpromedio)/count(distinct a.AnioCampana) as PDP3camps into #PDP3Camps
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  
on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais and a.AnioCampana = b.AnioCampana
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
inner join #ventascons d on a.PKEbelista =d.PKEbelista
where a.CodPais = @CodPais and CodTipoProfit = '01' and a.AnioCampana = a.AnioCampanaRef and RealVtaMNNeto > 0	
and a.AnioCampana in ('201713','201712', '201711')
group by a.PkEbelista
order by PkEBelista

SELECT * FROM #PDP3CAMPS

drop table #decil3camps
select PkEbelista, Ntile (10) over (order by PDP3camps desc) as [Decil], PDP3camps as PDP3camps into #decil3camps
FROM #PDP3CAMPS

select * from #decil3camps


drop table #cf_decil1
select a.*, b.PDP3camps, b.Decil into #cf_decil1
from #ventascons a left join #decil3camps b on a.PKEbelista = b.pkebelista

drop table #var41
select b.*, a.Decil as Decil3Camps, a.PDP3camps into #var41
from #cf_decil1 a inner join #var4 b on b.PKEbelista = a.PKEbelista



---------VAR 5-----------

select A.PkEbelista, AnioCampana, count( distinct (CONCAT(DesMarca,' ', DesCategoria,' ', DesTipoSolo))) as DiferentesMCT into #MCT
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA b on a.PKTipoOferta = b.PKTipoOferta  and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DPRODUCTO c on a.PkProducto = c.PkProducto and a.CodPais = c.CodPais
inner join #ventascons d on a.PKEbelista = d.PKEbelista 
where a.CodPais = @CodPais  and AnioCampana in ('201713','201712','201711') and AnioCampana = AnioCampanaRef and CodTipoProfit = '01'
GROUP BY A.PKEbelista, AnioCampana


drop table #MCTTrasp
SELECT Pkebelista, [201711] as mct201711,[201712] as mct201712, [201713] as mct201713  into #MCTTrasp
FROM
(    SELECT PKEbelista, AnioCampana, DiferentesMCT FROM #MCT
) AS SourceTable PIVOT(AVG([DiferentesMCT]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable


drop table #var5
select b.*, a.mct201711, mct201712, mct201713 into #var5
from #MCTTrasp a inner join #var41 b on b.PKEbelista = a.PKEbelista


---------VAR 6-----------
drop table #PPU
select  a.PKEbelista, AnioCampana, count(RealVtaMNNeto) as qprod, sum(RealVtaMNNeto/Realtcpromedio) as vta, sum(RealVtaMNNeto/Realtcpromedio)/count(RealVtaMNNeto) as PPU into #PPU
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA b on a.PKTipoOferta = b.PKTipoOferta  and a.CodPais = b.CodPais
inner join #ventascons d on a.PKEbelista = d.PKEbelista 
where a.CodPais = @CodPais  and AnioCampana in ('201713','201712','201711') and AnioCampana = AnioCampanaRef and CodTipoProfit = '01' and RealVtaMNNeto > 0
group by a.PKEbelista, AnioCampana
order by a.PkEbelista, AnioCampana

drop table #PPUTrasp
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713  into #PPUTrasp
FROM
(    SELECT PKEbelista, AnioCampana, PPU FROM #PPU
) AS SourceTable PIVOT(AVG([PPU]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable


select * from #PPUTrasp

drop table #var6
select b.*, a.v201711 as ppu201711, a.v201712 as ppu201712, a.v201713 as ppu201713 into #var6
from #PPUTrasp a inner join #var5 b on b.PKEbelista = a.PKEbelista



---------VAR 7-----------

drop table #TraspUnidades
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713  into #TraspUnidades
FROM
(    SELECT PKEbelista, AnioCampana, qprod FROM #PPU
) AS SourceTable PIVOT(AVG(qprod) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable



drop table #var7
select b.*, a.v201711 as Q201711, a.v201712 as Q201712, a.v201713 as Q201713 into #var7
from #TraspUnidades a inner join #var6 b on b.PKEbelista = a.PKEbelista



---------VAR 8-----------
drop table #IpUnico3camp
select PkEBelista, SUM(FlagIpUnicoZona)/3.0 as IpUnico into #IpUnico3camp
FROM [DWH_ANALITICO].DBO.DWH_FSTAEBECAM 
where CodPais = @CodPais  and AnioCampana in ('201713' , '201712','201711')
group by PKEbelista
ORDER BY SUM(FlagIpUnicoZona) DESC

drop table #var8
select a.*, b.IpUnico into #var8
from #var7 a left join #IpUnico3camp b 
on a.PKEbelista = b.PkEBelista




---------VAR 9-----------

--pdppalanca en ultimas 3 camps
drop table #PD
select a.PkEBELISTA, count(distinct AnioCampana)/3.0 as Cant_PD, sum(RealVtaMNNeto/realtcpromedio)/ count(distinct AnioCampana) as PDPPalancas
into #PD
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join #ventascons b on a.PKEbelista = B.PKEbelista
where CodPais = @CodPais  and AnioCampana in ('201713', '201712', '201711') 
and CodPalancaPersonalizacion <> '' and AnioCampana = AnioCampanaRef And RealVtaMNNeto > 0 
GROUP BY a.PKEbelista
order by a.PKEbelista


drop table #var9
select b.*, case when a.Cant_PD is not null then a.Cant_PD else 0 end	Cant_PD , 
case when a.PDPPalancas is not null then a.PDPPalancas else 0 end PDPPalancas into #var9
from #PD a right join #var8 b on b.PKEbelista = a.PKEbelista

select * from #var9

---------VAR 10-----------
select c.*, b.CodComportamientoRolling into #var10
from #ventascons a inner join #cosechaestablecidas b on a.PkEBELISTA = b.PkEBELISTA
inner join #var9 c on c.PKEbelista = b.PKEbelista

select * from #var10
---------VAR 11-----------
drop table #var11
select b.*, a.FechaNacimiento into #var11
from [DWH_ANALITICO].DBO.DWH_DEBELISTA a inner join #var10 b on a.PKEbelista = b.PKEbelista 
where CodPais = @CodPais

-- VAR 12: composicion canasta

drop table #marcas
select distinct PKEbelista, DesMarca, count(DesMarca) as qprod into #marcas
from DWH_ANALITICO.dbo.DWH_FVTAPROEBECAM a
inner join DWH_ANALITICO.dbo.DWH_DPRODUCTO b
on a.CodPais=b.CodPais and a.PkPRODUCTO = b.PkPRODUCTO
where a.CodPais = @CodPais  and AnioCampana in ('201713', '201712', '201711')  and DesMarca in ('CYZONE', 'ESIKA', 'L''BEL')
and PKEbelista IN (SELECT PKEbelista from #ventascons)
group by PKEbelista, DesMarca
ORDER BY PKEbelista, DesMarca

select PkEbelista, sum(qprod) as total_prod into #total
from #marcas
group by PkEbelista
ORDER BY PKEbelista

select a.pkebelista, a.desmarca, cast(qprod as decimal)/total_prod as share_marca into #share 
from #marcas a inner join #total b on a.PkEbelista = b.PkEbelista
order by pkebelista
select * from #share

drop table #sharetrasp
SELECT Pkebelista, [CYZONE] as CYZONE,[L'BEL] as LBEL, [ESIKA] as ESIKA into #sharetrasp
FROM
(    SELECT * FROM #share
) AS SourceTable PIVOT(AVG([share_marca]) FOR [desmarca] IN([CYZONE],[L'BEL], [ESIKA])) AS PivotTable


DROP TABLE #var12
select a.*, b.CYZONE, b.ESIKA, b.LBEL
into #var12
FROM #var11 a left join #sharetrasp b on a.PkEBELISTA = B.pKebelista

-------VAR 13: Primer pedido
drop table #var13
select a.*, b.AnioCampanaPrimerPedido, b.AnioCampanaPrimerPedWeb, b.AnioCampanaIngreso into #var13
from #var12 a left join DWH_ANALITICO.dbo.DWH_DEBELISTA b on a.PkEbelista = b.PKEbelista 
where CodPais = @CodPais


select *, case when CYZONE is not null then CYZONE else 0 end CYZONE_SH,
 case when ESIKA is not null then ESIKA else 0 end ESIKA_SH,
 case when LBEL is not null then LBEL else 0 end LBEL_SH  into CR_INPUT_V2_PE from #var13


select * from CR_INPUT_V2_PE

