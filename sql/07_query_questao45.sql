-- ============================================================
-- QUERY 3 — Respostas da questão 45 filtradas por escola (CNPJ)
-- ============================================================
SELECT
    p.nome_completo             AS aluno,
    r.alternativa_escolhida,
    r.esta_correta
FROM public.respostas r
JOIN public.sessoes_simulado ss ON ss.id = r.sessao_id
JOIN public.perfis p            ON p.id  = ss.aluno_id
JOIN public.questoes q          ON q.id  = r.questao_id
JOIN public.matriculas m        ON m.aluno_id = p.id
JOIN public.escolas e           ON e.id = m.escola_id
WHERE q.numero = 45
  AND e.cnpj   = '12345678000199'
ORDER BY p.nome_completo;
