-- ============================================================
-- QUERY 5 — Auditoria de totalizadores inconsistentes
-- Detecta sessões onde total_questoes ou total_acertos divergem
-- da contagem real na tabela de respostas
-- ============================================================
SELECT
    ss.id                               AS sessao_id,
    ss.total_questoes                   AS total_questoes_armazenado,
    COUNT(r.id)                         AS contagem_real_respostas,
    ss.total_acertos                    AS total_acertos_armazenado,
    COUNT(r.id) FILTER (WHERE r.esta_correta = true) AS contagem_real_acertos
FROM public.sessoes_simulado ss
LEFT JOIN public.respostas r ON r.sessao_id = ss.id
WHERE ss.status = 'concluida'
GROUP BY ss.id, ss.total_questoes, ss.total_acertos
HAVING
    ss.total_questoes <> COUNT(r.id)
    OR ss.total_acertos <> COUNT(r.id) FILTER (WHERE r.esta_correta = true)
ORDER BY ss.id;
