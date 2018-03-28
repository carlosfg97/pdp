
---------VAR OBJETIVO-----------
drop table #cosechaestablecidas
select CodPais, AnioCampana, PkEbelista, CodComportamientoRolling into #cosechaestablecidas
from  [DWH_ANALITICO].DBO.DWH_FSTAEBECAM
where CodPais = 'PE'  and AnioCampana = '201713' and CodComportamientoRolling in (2, 3,4,5,6,7) 


drop table #vtas3camp
select a.PkEbelista, a.AnioCampana, sum(RealVtaMNNeto/Realtcpromedio) as vta
into #vtas3camp
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
where a.CodPais = 'PE' 
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


drop table #ventascons1										
select * into #ventascons1 from #vtasTrasp where 
v201711 is not null and
v201712 is not null
and  v201713 is not null and  v201715 is not null



drop table #ventascons
select *,
case
when (v201713 + v201711 + v201712)/3 > v201715
and (v201715/v201713 -1 )*100 < -10 then 1
else 0 
end as [Target] into #ventascons
from #ventascons1

select * from #ventascons



---------VAR 2-----------
drop table #pedidos_ult_18camp
select b.PkEBELISTA, sum(FlagPasoPedido) as Pedidos_ult_18camp into #pedidos_ult_18camp
from #ventascons a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b on a.PkEbelista = b.PkEbelista
where b.AnioCampana in ('201713','201712','201711','201710','201709','201708','201707','201706','201705',
'201704','201703','201702','201701','201618','201617','201616','201615','201614') and CodPais = 'PE'
group by b.Pkebelista 

drop table #var2
select b.*, a.Pedidos_ult_18camp into #var2
from #pedidos_ult_18camp a inner join #ventascons b on a.PKEbelista =b.PKEbelista

select * from #var2

---------VAR 3-----------


drop table #PMNPañoanterior
select a.PkEbelista, sum(RealVtaMNNeto/Realtcpromedio) as vta, count(distinct a.AnioCampana) as CampañaPasoPedido, sum(RealVtaMNNeto/Realtcpromedio)/count(distinct a.AnioCampana) as PDP into #PMNPañoanterior
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
inner join #ventascons d on a.PKEbelista =d.PKEbelista
where a.CodPais = 'PE' 
and CodTipoProfit = '01'
and a.AnioCampana in ('201701','201618','201617','201616','201615','201614','201613')
and a.AnioCampana = a.AnioCampanaRef
and RealVtaMNNeto > 0
group by a.PkEbelista
order by PkEBelista

select * from #PMNPañoanterior

drop table #decilañoanterior
select PkEbelista, Ntile (10) over (order by PDP desc) as [Decil], PDP as PDPAñoAnterior into #decilañoanterior
FROM #PMNPañoanterior

drop table #decil
select a.*, b.PDPAñoAnterior, b.Decil into #decil
from #ventascons a  left join #decilañoanterior b on a.PKEbelista = b.pkebelista


select b.*, a.Decil as DecilAñoAnterior, a.PDPAñoAnterior into #var3
from #decil a inner join #var2 b on b.PKEbelista = a.PKEbelista

select * from #var3

---------VAR 4-----------
drop table #PDPCampanterior
select a.PkEbelista, sum(RealVtaMNNeto/Realtcpromedio) as vta, count(distinct a.AnioCampana) as CampañaPasoPedido, sum(RealVtaMNNeto/Realtcpromedio)/count(distinct a.AnioCampana) as PDP into #PDPCampanterior
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_FSTAEBECAM b  on a.PkEbelista = b.PkEBELISTA and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA c on  a.PKTipoOferta = c.PKTipoOferta  and a.CodPais = c.CodPais 
inner join #ventascons d on a.PKEbelista =d.PKEbelista
where a.CodPais = 'PE' 
and CodTipoProfit = '01'
and a.AnioCampana = '201713'
and a.AnioCampana = a.AnioCampanaRef
and RealVtaMNNeto > 0
group by a.PkEbelista
order by PkEBelista

SELECT * FROM #PDPCampanterior

drop table #decilcampanterior
select PkEbelista, Ntile (10) over (order by PMNP desc) as [Decil], PMNP as PMNPCampAnterior into #DecilCampAnterior
FROM #PMNPCampanterior

drop table #cf_decil
select a.*, b.PMNPCampAnterior, b.Decil into #cf_decil
from #ventascons a  left join #decilcampanterior b on a.PKEbelista = b.pkebelista


select b.*, a.Decil as DecilCampAnterior, a.PMNPCampAnterior into #var4
from #cf_decil a inner join #var3 b on b.PKEbelista = a.PKEbelista


---------VAR 5-----------

select A.PkEbelista, AnioCampana, count( distinct (CONCAT(DesMarca,' ', DesCategoria,' ', DesTipoSolo))) as DiferentesMCT into #MCT
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA b on a.PKTipoOferta = b.PKTipoOferta  and a.CodPais = b.CodPais
inner join [DWH_ANALITICO].DBO.DWH_DPRODUCTO c on a.PkProducto = c.PkProducto and a.CodPais = c.CodPais
inner join #ventascons d on a.PKEbelista = d.PKEbelista 
where a.CodPais = 'PE'  and AnioCampana in ('201713','201712','201711') and AnioCampana = AnioCampanaRef and CodTipoProfit = '01'
GROUP BY A.PKEbelista, AnioCampana


drop table #MCTTrasp
SELECT Pkebelista, [201711] as mct201711,[201712] as mct201712, [201713] as mct201713  into #MCTTrasp
FROM
(    SELECT PKEbelista, AnioCampana, DiferentesMCT FROM #MCT
) AS SourceTable PIVOT(AVG([DiferentesMCT]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable



select b.*, a.mct201711, mct201712, mct201713 into #var5
from #MCTTrasp a inner join #var4 b on b.PKEbelista = a.PKEbelista


---------VAR 6-----------
drop table #PPU
select  a.PKEbelista, AnioCampana, count(RealVtaMNNeto) as qprod, sum(RealVtaMNNeto/Realtcpromedio) as vta, sum(RealVtaMNNeto/Realtcpromedio)/count(RealVtaMNNeto) as PPU into #PPU
from [DWH_ANALITICO].DBO.DWH_FVTAPROEBECAM a inner join [DWH_ANALITICO].DBO.DWH_DTIPOOFERTA b on a.PKTipoOferta = b.PKTipoOferta  and a.CodPais = b.CodPais
inner join #ventascons d on a.PKEbelista = d.PKEbelista 
where a.CodPais = 'PE'  and AnioCampana in ('201713','201712','201711') and AnioCampana = AnioCampanaRef and CodTipoProfit = '01' and RealVtaMNNeto > 0
group by a.PKEbelista, AnioCampana
order by a.PkEbelista, AnioCampana

drop table #PPUTrasp
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713  into #PPUTrasp
FROM
(    SELECT PKEbelista, AnioCampana, PPU FROM #PPU
) AS SourceTable PIVOT(AVG([PPU]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable


select * from #PPUTrasp

select b.*, a.v201711 as ppu201711, a.v201712 as ppu201712, a.v201713 as ppu201713 into #var6
from #PPUTrasp a inner join #var5 b on b.PKEbelista = a.PKEbelista

select * from #var6


---------VAR 7-----------



drop table #TraspUnidades
SELECT Pkebelista, [201711] as v201711,[201712] as v201712, [201713] as v201713  into #TraspUnidades
FROM
(    SELECT PKEbelista, AnioCampana, qprod FROM #PPU
) AS SourceTable PIVOT(AVG(qprod) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable

select * from #TraspUnidades

select b.*, a.v201711 as Q201711, a.v201712 as Q201712, a.v201713 as Q201713 into #var7
from #TraspUnidades a inner join #var6 b on b.PKEbelista = a.PKEbelista



---------VAR 8-----------

SELECT d.*, FlagIpUnicoZona into #var8
FROM [DWH_ANALITICO].DBO.DWH_FSTAEBECAM a 
inner join #var7 d on a.PKEbelista = d.PKEbelista 
where CodPais = 'PE'  and AnioCampana = '201713' 



---------VAR 9-----------

drop table #PD
SELECT a.PkEbelista, AnioCampana, FlagCompraOPT + FlagCompraODD + FlagCompraOF + FlagCompraFDC + FlagCompraSR as PalancaDigital into #PD
FROM [DWH_ANALITICO].DBO.DWH_FSTAEBECAM a inner join #ventascons b on a.PKEbelista = B.PKEbelista
where CodPais = 'PE'  and AnioCampana in ('201713', '201712', '201711')
order by a.PkEBELISTA


drop table #PDTrasp
SELECT Pkebelista, [201711] as pd201711,[201712] as pd201712, [201713] as pd201713  into #PDTrasp
FROM
(    SELECT * FROM #pd
) AS SourceTable PIVOT(AVG([PalancaDigital]) FOR [AnioCampana] IN([201711], [201712],
[201713])) AS PivotTable


select * from #PDTrasp

select b.*, a.pd201711, a.pd201712, a.pd201713 into #var9
from #PDTrasp a inner join #var8 b on b.PKEbelista = a.PKEbelista

---------VAR 10-----------
select c.*, b.CodComportamientoRolling into #var10
from #ventascons a inner join #cosechaestablecidas b on a.PkEBELISTA = b.PkEBELISTA
inner join #var9 c on c.PKEbelista = b.PKEbelista

select * from #var10

---------VAR 11-----------
drop table CR_INPUT1_PDP_PE
select b.*, a.FechaNacimiento into CR_INPUT1_PDP_PE
from [DWH_ANALITICO].DBO.DWH_DEBELISTA a inner join #var10 b on a.PKEbelista = b.PKEbelista 
where CodPais = 'PE'

select * from CR_INPUT1_PDP_PE
													
						