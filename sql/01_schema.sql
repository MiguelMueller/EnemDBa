-- ============================================================
-- SIMULADOR ENEM — 01_schema.sql
-- CREATE TABLE, PKs, FKs, constraints
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- perfis
-- Nota: auth_id referencia auth.users em produção (Supabase).
-- A FK foi omitida para permitir testes sem o sistema de auth.
-- ============================================================
CREATE TABLE public.perfis (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_id         UUID NOT NULL UNIQUE,
    nome_completo   TEXT NOT NULL,
    papel           TEXT NOT NULL DEFAULT 'aluno'
                        CHECK (papel IN ('aluno', 'admin_escolar', 'admin_global')),
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- escolas
-- ============================================================
CREATE TABLE public.escolas (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome            TEXT NOT NULL,
    cnpj            CHAR(14) NOT NULL UNIQUE,
    admin_id        UUID NOT NULL REFERENCES public.perfis(id) ON DELETE RESTRICT,
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_cnpj_formato CHECK (cnpj ~ '^\d{14}$')
);

-- ============================================================
-- matriculas
-- ============================================================
CREATE TABLE public.matriculas (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aluno_id        UUID NOT NULL REFERENCES public.perfis(id)  ON DELETE CASCADE,
    escola_id       UUID NOT NULL REFERENCES public.escolas(id) ON DELETE CASCADE,
    matriculado_em  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_matricula UNIQUE (aluno_id, escola_id)
);

-- ============================================================
-- questoes
-- ============================================================
CREATE TABLE public.questoes (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    numero          INT NOT NULL,
    enunciado       JSONB NOT NULL,
    alternativas    JSONB NOT NULL,
    criado_em       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_questoes_enunciado    ON public.questoes USING GIN (enunciado);
CREATE INDEX idx_questoes_alternativas ON public.questoes USING GIN (alternativas);

-- ============================================================
-- sessoes_simulado
-- ============================================================
CREATE TABLE public.sessoes_simulado (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aluno_id        UUID NOT NULL REFERENCES public.perfis(id) ON DELETE CASCADE,
    status          TEXT NOT NULL DEFAULT 'em_andamento'
                        CHECK (status IN ('em_andamento', 'concluida')),
    iniciado_em     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finalizado_em   TIMESTAMPTZ,
    total_questoes  INT NOT NULL DEFAULT 0 CHECK (total_questoes >= 0),
    total_acertos   INT NOT NULL DEFAULT 0 CHECK (total_acertos >= 0),
    CONSTRAINT chk_acertos_lte_total CHECK (total_acertos <= total_questoes),
    CONSTRAINT chk_fim_apos_inicio
        CHECK (finalizado_em IS NULL OR finalizado_em >= iniciado_em)
);

-- ============================================================
-- respostas
-- ============================================================
CREATE TABLE public.respostas (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sessao_id               UUID NOT NULL REFERENCES public.sessoes_simulado(id) ON DELETE CASCADE,
    questao_id              UUID NOT NULL REFERENCES public.questoes(id)          ON DELETE CASCADE,
    alternativa_escolhida   INT NOT NULL,
    esta_correta            BOOLEAN NOT NULL,
    respondido_em           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_resposta_por_sessao UNIQUE (sessao_id, questao_id)
);

CREATE INDEX idx_respostas_sessao  ON public.respostas (sessao_id);
CREATE INDEX idx_respostas_questao ON public.respostas (questao_id);
