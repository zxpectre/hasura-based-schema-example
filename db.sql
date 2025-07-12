--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg110+1)
-- Dumped by pg_dump version 16.9


CREATE TABLE public.ada_pots (
    id bigint NOT NULL,
    slot_no public.word63type NOT NULL,
    epoch_no public.word31type NOT NULL,
    treasury public.lovelace NOT NULL,
    reserves public.lovelace NOT NULL,
    rewards public.lovelace NOT NULL,
    utxo public.lovelace NOT NULL,
    deposits_stake public.lovelace NOT NULL,
    fees public.lovelace NOT NULL,
    block_id bigint NOT NULL,
    deposits_drep public.lovelace NOT NULL,
    deposits_proposal public.lovelace NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 16682)
-- Name: block; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.block (
    id bigint NOT NULL,
    hash public.hash32type NOT NULL,
    epoch_no public.word31type,
    slot_no public.word63type,
    epoch_slot_no public.word31type,
    block_no public.word31type,
    previous_id bigint,
    slot_leader_id bigint NOT NULL,
    size public.word31type NOT NULL,
    "time" timestamp without time zone NOT NULL,
    tx_count bigint NOT NULL,
    proto_major public.word31type NOT NULL,
    proto_minor public.word31type NOT NULL,
    vrf_key character varying,
    op_cert public.hash32type,
    op_cert_counter public.word63type
);


--
-- TOC entry 278 (class 1259 OID 16817)
-- Name: collateral_tx_in; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collateral_tx_in (
    id bigint NOT NULL,
    tx_in_id bigint NOT NULL,
    tx_out_id bigint NOT NULL,
    tx_out_index public.txindex NOT NULL
);


--
-- TOC entry 341 (class 1259 OID 17519)
-- Name: collateral_tx_out; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.collateral_tx_out (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    index public.txindex NOT NULL,
    address character varying NOT NULL,
    address_has_script boolean NOT NULL,
    payment_cred public.hash28type,
    stake_address_id bigint,
    value public.lovelace NOT NULL,
    data_hash public.hash32type,
    multi_assets_descr character varying NOT NULL,
    inline_datum_id bigint,
    reference_script_id bigint
);


--
-- TOC entry 360 (class 1259 OID 17717)
-- Name: committee_de_registration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_de_registration (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    cert_index integer NOT NULL,
    voting_anchor_id bigint,
    cold_key_id bigint NOT NULL
);


--
-- TOC entry 358 (class 1259 OID 17708)
-- Name: committee_registration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_registration (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    cert_index integer NOT NULL,
    cold_key_id bigint NOT NULL,
    hot_key_id bigint NOT NULL
);


--
-- TOC entry 380 (class 1259 OID 17811)
-- Name: constitution; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.constitution (
    id bigint NOT NULL,
    gov_action_proposal_id bigint,
    voting_anchor_id bigint NOT NULL,
    script_hash public.hash28type
);


--
-- TOC entry 323 (class 1259 OID 17245)
-- Name: cost_model; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cost_model (
    id bigint NOT NULL,
    costs jsonb NOT NULL,
    hash public.hash32type NOT NULL
);


--
-- TOC entry 272 (class 1259 OID 16756)
-- Name: datum; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datum (
    id bigint NOT NULL,
    hash public.hash32type NOT NULL,
    tx_id bigint NOT NULL,
    value jsonb,
    bytes bytea NOT NULL
);


--
-- TOC entry 300 (class 1259 OID 17021)
-- Name: delegation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delegation (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    cert_index integer NOT NULL,
    pool_hash_id bigint NOT NULL,
    active_epoch_no bigint NOT NULL,
    tx_id bigint NOT NULL,
    slot_no public.word63type NOT NULL,
    redeemer_id bigint
);


--
-- TOC entry 356 (class 1259 OID 17701)
-- Name: delegation_vote; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delegation_vote (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    cert_index integer NOT NULL,
    drep_hash_id bigint NOT NULL,
    tx_id bigint NOT NULL,
    redeemer_id bigint
);


--
-- TOC entry 337 (class 1259 OID 17400)
-- Name: delisted_pool; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.delisted_pool (
    id bigint NOT NULL,
    hash_raw public.hash28type NOT NULL
);


--
-- TOC entry 374 (class 1259 OID 17780)
-- Name: drep_distr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drep_distr (
    id bigint NOT NULL,
    hash_id bigint NOT NULL,
    amount bigint NOT NULL,
    epoch_no public.word31type NOT NULL,
    active_until public.word31type
);


--
-- TOC entry 354 (class 1259 OID 17690)
-- Name: drep_hash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drep_hash (
    id bigint NOT NULL,
    raw public.hash28type,
    view character varying NOT NULL,
    has_script boolean NOT NULL
);


--
-- TOC entry 362 (class 1259 OID 17726)
-- Name: drep_registration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drep_registration (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    cert_index integer NOT NULL,
    deposit bigint,
    drep_hash_id bigint NOT NULL,
    voting_anchor_id bigint
);


--
-- TOC entry 282 (class 1259 OID 16847)
-- Name: epoch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epoch (
    id bigint NOT NULL,
    out_sum public.word128type NOT NULL,
    fees public.lovelace NOT NULL,
    tx_count public.word31type NOT NULL,
    blk_count public.word31type NOT NULL,
    no public.word31type NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL
);


--
-- TOC entry 327 (class 1259 OID 17282)
-- Name: epoch_param; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epoch_param (
    id bigint NOT NULL,
    epoch_no public.word31type NOT NULL,
    min_fee_a public.word31type NOT NULL,
    min_fee_b public.word31type NOT NULL,
    max_block_size public.word31type NOT NULL,
    max_tx_size public.word31type NOT NULL,
    max_bh_size public.word31type NOT NULL,
    key_deposit public.lovelace NOT NULL,
    pool_deposit public.lovelace NOT NULL,
    max_epoch public.word31type NOT NULL,
    optimal_pool_count public.word31type NOT NULL,
    influence double precision NOT NULL,
    monetary_expand_rate double precision NOT NULL,
    treasury_growth_rate double precision NOT NULL,
    decentralisation double precision NOT NULL,
    protocol_major public.word31type NOT NULL,
    protocol_minor public.word31type NOT NULL,
    min_utxo_value public.lovelace NOT NULL,
    min_pool_cost public.lovelace NOT NULL,
    nonce public.hash32type,
    cost_model_id bigint,
    price_mem double precision,
    price_step double precision,
    max_tx_ex_mem public.word64type,
    max_tx_ex_steps public.word64type,
    max_block_ex_mem public.word64type,
    max_block_ex_steps public.word64type,
    max_val_size public.word64type,
    collateral_percent public.word31type,
    max_collateral_inputs public.word31type,
    block_id bigint NOT NULL,
    extra_entropy public.hash32type,
    coins_per_utxo_size public.lovelace,
    pvt_motion_no_confidence double precision,
    pvt_committee_normal double precision,
    pvt_committee_no_confidence double precision,
    pvt_hard_fork_initiation double precision,
    dvt_motion_no_confidence double precision,
    dvt_committee_normal double precision,
    dvt_committee_no_confidence double precision,
    dvt_update_to_constitution double precision,
    dvt_hard_fork_initiation double precision,
    dvt_p_p_network_group double precision,
    dvt_p_p_economic_group double precision,
    dvt_p_p_technical_group double precision,
    dvt_p_p_gov_group double precision,
    dvt_treasury_withdrawal double precision,
    committee_min_size public.word64type,
    committee_max_term_length public.word64type,
    gov_action_lifetime public.word64type,
    gov_action_deposit public.word64type,
    drep_deposit public.word64type,
    drep_activity public.word64type,
    pvtpp_security_group double precision,
    min_fee_ref_script_cost_per_byte double precision
);


--
-- TOC entry 307 (class 1259 OID 17111)
-- Name: epoch_stake; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epoch_stake (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    pool_id bigint NOT NULL,
    amount public.lovelace NOT NULL,
    epoch_no public.word31type NOT NULL
);


--
-- TOC entry 349 (class 1259 OID 17648)
-- Name: epoch_stake_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epoch_stake_progress (
    id bigint NOT NULL,
    epoch_no public.word31type NOT NULL,
    completed boolean NOT NULL
);


--
-- TOC entry 315 (class 1259 OID 17188)
-- Name: epoch_sync_time; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epoch_sync_time (
    id bigint NOT NULL,
    no bigint NOT NULL,
    seconds public.word63type NOT NULL,
    state public.syncstatetype NOT NULL
);


--
-- TOC entry 339 (class 1259 OID 17420)
-- Name: extra_key_witness; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.extra_key_witness (
    id bigint NOT NULL,
    hash public.hash28type NOT NULL,
    tx_id bigint NOT NULL
);


--
-- TOC entry 351 (class 1259 OID 17657)
-- Name: extra_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.extra_migrations (
    id bigint NOT NULL,
    token character varying NOT NULL,
    description character varying
);


--
-- TOC entry 366 (class 1259 OID 17744)
-- Name: gov_action_proposal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gov_action_proposal (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    index bigint NOT NULL,
    prev_gov_action_proposal bigint,
    deposit public.lovelace NOT NULL,
    return_address bigint NOT NULL,
    expiration public.word31type,
    voting_anchor_id bigint,
    type public.govactiontype NOT NULL,
    description jsonb NOT NULL,
    param_proposal bigint,
    ratified_epoch public.word31type,
    enacted_epoch public.word31type,
    dropped_epoch public.word31type,
    expired_epoch public.word31type
);


--
-- TOC entry 317 (class 1259 OID 17197)
-- Name: ma_tx_mint; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ma_tx_mint (
    id bigint NOT NULL,
    quantity public.int65type NOT NULL,
    tx_id bigint NOT NULL,
    ident bigint NOT NULL
);


--
-- TOC entry 319 (class 1259 OID 17213)
-- Name: ma_tx_out; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ma_tx_out (
    id bigint NOT NULL,
    quantity public.word64type NOT NULL,
    tx_out_id bigint NOT NULL,
    ident bigint NOT NULL
);


--
-- TOC entry 280 (class 1259 OID 16836)
-- Name: meta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meta (
    id bigint NOT NULL,
    start_time timestamp without time zone NOT NULL,
    network_name character varying NOT NULL,
    version character varying NOT NULL
);


--
-- TOC entry 335 (class 1259 OID 17373)
-- Name: multi_asset; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.multi_asset (
    id bigint NOT NULL,
    policy public.hash28type NOT NULL,
    name public.asset32type NOT NULL,
    fingerprint character varying NOT NULL
);


--
-- TOC entry 370 (class 1259 OID 17762)
-- Name: new_committee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_committee (
    id bigint NOT NULL,
    gov_action_proposal_id bigint NOT NULL,
    deleted_members character varying NOT NULL,
    added_members character varying NOT NULL,
    quorum_numerator bigint NOT NULL,
    quorum_denominator bigint NOT NULL
);


--
-- TOC entry 329 (class 1259 OID 17303)
-- Name: off_chain_pool_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_pool_data (
    id bigint NOT NULL,
    pool_id bigint NOT NULL,
    ticker_name character varying NOT NULL,
    hash public.hash32type NOT NULL,
    json jsonb NOT NULL,
    bytes bytea NOT NULL,
    pmr_id bigint NOT NULL
);


--
-- TOC entry 331 (class 1259 OID 17324)
-- Name: off_chain_pool_fetch_error; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_pool_fetch_error (
    id bigint NOT NULL,
    pool_id bigint NOT NULL,
    fetch_time timestamp without time zone NOT NULL,
    pmr_id bigint NOT NULL,
    fetch_error character varying NOT NULL,
    retry_count public.word31type NOT NULL
);


--
-- TOC entry 376 (class 1259 OID 17789)
-- Name: off_chain_vote_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_data (
    id bigint NOT NULL,
    voting_anchor_id bigint NOT NULL,
    hash bytea NOT NULL,
    json jsonb NOT NULL,
    bytes bytea NOT NULL,
    warning character varying,
    language character varying NOT NULL,
    comment character varying,
    is_valid boolean
);


--
-- TOC entry 378 (class 1259 OID 17800)
-- Name: off_chain_vote_fetch_error; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_fetch_error (
    id bigint NOT NULL,
    voting_anchor_id bigint NOT NULL,
    fetch_error character varying NOT NULL,
    fetch_time timestamp without time zone NOT NULL,
    retry_count public.word31type NOT NULL
);


--
-- TOC entry 325 (class 1259 OID 17261)
-- Name: param_proposal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.param_proposal (
    id bigint NOT NULL,
    epoch_no public.word31type,
    key public.hash28type,
    min_fee_a public.word64type,
    min_fee_b public.word64type,
    max_block_size public.word64type,
    max_tx_size public.word64type,
    max_bh_size public.word64type,
    key_deposit public.lovelace,
    pool_deposit public.lovelace,
    max_epoch public.word64type,
    optimal_pool_count public.word64type,
    influence double precision,
    monetary_expand_rate double precision,
    treasury_growth_rate double precision,
    decentralisation double precision,
    entropy public.hash32type,
    protocol_major public.word31type,
    protocol_minor public.word31type,
    min_utxo_value public.lovelace,
    min_pool_cost public.lovelace,
    cost_model_id bigint,
    price_mem double precision,
    price_step double precision,
    max_tx_ex_mem public.word64type,
    max_tx_ex_steps public.word64type,
    max_block_ex_mem public.word64type,
    max_block_ex_steps public.word64type,
    max_val_size public.word64type,
    collateral_percent public.word31type,
    max_collateral_inputs public.word31type,
    registered_tx_id bigint NOT NULL,
    coins_per_utxo_size public.lovelace,
    pvt_motion_no_confidence double precision,
    pvt_committee_normal double precision,
    pvt_committee_no_confidence double precision,
    pvt_hard_fork_initiation double precision,
    dvt_motion_no_confidence double precision,
    dvt_committee_normal double precision,
    dvt_committee_no_confidence double precision,
    dvt_update_to_constitution double precision,
    dvt_hard_fork_initiation double precision,
    dvt_p_p_network_group double precision,
    dvt_p_p_economic_group double precision,
    dvt_p_p_technical_group double precision,
    dvt_p_p_gov_group double precision,
    dvt_treasury_withdrawal double precision,
    committee_min_size public.word64type,
    committee_max_term_length public.word64type,
    gov_action_lifetime public.word64type,
    gov_action_deposit public.word64type,
    drep_deposit public.word64type,
    drep_activity public.word64type,
    pvtpp_security_group double precision,
    min_fee_ref_script_cost_per_byte double precision
);


--
-- TOC entry 260 (class 1259 OID 16655)
-- Name: pool_hash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_hash (
    id bigint NOT NULL,
    hash_raw public.hash28type NOT NULL,
    view character varying NOT NULL
);


--
-- TOC entry 286 (class 1259 OID 16874)
-- Name: pool_metadata_ref; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_metadata_ref (
    id bigint NOT NULL,
    pool_id bigint NOT NULL,
    url character varying NOT NULL,
    hash public.hash32type NOT NULL,
    registered_tx_id bigint NOT NULL
);


--
-- TOC entry 290 (class 1259 OID 16921)
-- Name: pool_owner; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_owner (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    pool_update_id bigint NOT NULL
);


--
-- TOC entry 294 (class 1259 OID 16962)
-- Name: pool_relay; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_relay (
    id bigint NOT NULL,
    update_id bigint NOT NULL,
    ipv4 character varying,
    ipv6 character varying,
    dns_name character varying,
    dns_srv_name character varying,
    port integer
);


--
-- TOC entry 292 (class 1259 OID 16943)
-- Name: pool_retire; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_retire (
    id bigint NOT NULL,
    hash_id bigint NOT NULL,
    cert_index integer NOT NULL,
    announced_tx_id bigint NOT NULL,
    retiring_epoch public.word31type NOT NULL
);


--
-- TOC entry 288 (class 1259 OID 16895)
-- Name: pool_update; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_update (
    id bigint NOT NULL,
    hash_id bigint NOT NULL,
    cert_index integer NOT NULL,
    vrf_key_hash public.hash32type NOT NULL,
    pledge public.lovelace NOT NULL,
    active_epoch_no bigint NOT NULL,
    meta_id bigint,
    margin double precision NOT NULL,
    fixed_cost public.lovelace NOT NULL,
    registered_tx_id bigint NOT NULL,
    reward_addr_id bigint NOT NULL,
    deposit public.lovelace
);


--
-- TOC entry 313 (class 1259 OID 17172)
-- Name: pot_transfer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pot_transfer (
    id bigint NOT NULL,
    cert_index integer NOT NULL,
    treasury public.int65type NOT NULL,
    reserves public.int65type NOT NULL,
    tx_id bigint NOT NULL
);


--
-- TOC entry 274 (class 1259 OID 16772)
-- Name: redeemer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redeemer (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    unit_mem public.word63type NOT NULL,
    unit_steps public.word63type NOT NULL,
    fee public.lovelace,
    purpose public.scriptpurposetype NOT NULL,
    index public.word31type NOT NULL,
    script_hash public.hash28type,
    redeemer_data_id bigint NOT NULL
);


--
-- TOC entry 345 (class 1259 OID 17561)
-- Name: redeemer_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redeemer_data (
    id bigint NOT NULL,
    hash public.hash32type NOT NULL,
    tx_id bigint NOT NULL,
    value jsonb,
    bytes bytea NOT NULL
);


--
-- TOC entry 343 (class 1259 OID 17540)
-- Name: reference_tx_in; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_tx_in (
    id bigint NOT NULL,
    tx_in_id bigint NOT NULL,
    tx_out_id bigint NOT NULL,
    tx_out_index public.txindex NOT NULL
);


--
-- TOC entry 311 (class 1259 OID 17151)
-- Name: reserve; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reserve (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    cert_index integer NOT NULL,
    amount public.int65type NOT NULL,
    tx_id bigint NOT NULL
);


--
-- TOC entry 333 (class 1259 OID 17356)
-- Name: reserved_pool_ticker; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reserved_pool_ticker (
    id bigint NOT NULL,
    name character varying NOT NULL,
    pool_hash public.hash28type NOT NULL
);


--
-- TOC entry 347 (class 1259 OID 17636)
-- Name: reverse_index; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reverse_index (
    id bigint NOT NULL,
    block_id bigint NOT NULL,
    min_ids character varying NOT NULL
);


--
-- TOC entry 303 (class 1259 OID 17066)
-- Name: reward; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reward (
    addr_id bigint NOT NULL,
    type public.rewardtype NOT NULL,
    amount public.lovelace NOT NULL,
    spendable_epoch bigint NOT NULL,
    pool_id bigint NOT NULL,
    earned_epoch bigint GENERATED ALWAYS AS (
CASE
    WHEN (type = 'refund'::public.rewardtype) THEN spendable_epoch
    ELSE
    CASE
        WHEN (spendable_epoch >= 2) THEN (spendable_epoch - 2)
        ELSE (0)::bigint
    END
END) STORED NOT NULL
);


--
-- TOC entry 258 (class 1259 OID 16527)
-- Name: schema_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version (
    id bigint NOT NULL,
    stage_one bigint NOT NULL,
    stage_two bigint NOT NULL,
    stage_three bigint NOT NULL
);


--
-- TOC entry 321 (class 1259 OID 17229)
-- Name: script; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.script (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    hash public.hash28type NOT NULL,
    type public.scripttype NOT NULL,
    json jsonb,
    bytes bytea,
    serialised_size public.word31type
);


--
-- TOC entry 262 (class 1259 OID 16666)
-- Name: slot_leader; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.slot_leader (
    id bigint NOT NULL,
    hash public.hash28type NOT NULL,
    pool_hash_id bigint,
    description character varying NOT NULL
);


--
-- TOC entry 268 (class 1259 OID 16719)
-- Name: stake_address; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stake_address (
    id bigint NOT NULL,
    hash_raw public.addr29type NOT NULL,
    view character varying NOT NULL,
    script_hash public.hash28type
);


--
-- TOC entry 298 (class 1259 OID 16997)
-- Name: stake_deregistration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stake_deregistration (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    cert_index integer NOT NULL,
    epoch_no public.word31type NOT NULL,
    tx_id bigint NOT NULL,
    redeemer_id bigint
);


--
-- TOC entry 296 (class 1259 OID 16978)
-- Name: stake_registration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stake_registration (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    cert_index integer NOT NULL,
    epoch_no public.word31type NOT NULL,
    tx_id bigint NOT NULL,
    deposit public.lovelace
);


--
-- TOC entry 309 (class 1259 OID 17130)
-- Name: treasury; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.treasury (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    cert_index integer NOT NULL,
    amount public.int65type NOT NULL,
    tx_id bigint NOT NULL
);


--
-- TOC entry 368 (class 1259 OID 17753)
-- Name: treasury_withdrawal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.treasury_withdrawal (
    id bigint NOT NULL,
    gov_action_proposal_id bigint NOT NULL,
    stake_address_id bigint NOT NULL,
    amount public.lovelace NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 16703)
-- Name: tx; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tx (
    id bigint NOT NULL,
    hash public.hash32type NOT NULL,
    block_id bigint NOT NULL,
    block_index public.word31type NOT NULL,
    out_sum public.lovelace NOT NULL,
    fee public.lovelace NOT NULL,
    deposit bigint,
    size public.word31type NOT NULL,
    invalid_before public.word64type,
    invalid_hereafter public.word64type,
    valid_contract boolean NOT NULL,
    script_size public.word31type NOT NULL,
    treasury_donation public.lovelace DEFAULT 0 NOT NULL
);


--
-- TOC entry 276 (class 1259 OID 16793)
-- Name: tx_in; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tx_in (
    id bigint NOT NULL,
    tx_in_id bigint NOT NULL,
    tx_out_id bigint NOT NULL,
    tx_out_index public.txindex NOT NULL,
    redeemer_id bigint
);


--
-- TOC entry 270 (class 1259 OID 16735)
-- Name: tx_out; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tx_out (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    index public.txindex NOT NULL,
    address character varying NOT NULL,
    address_has_script boolean NOT NULL,
    payment_cred public.hash28type,
    stake_address_id bigint,
    value public.lovelace NOT NULL,
    data_hash public.hash32type,
    inline_datum_id bigint,
    reference_script_id bigint,
    consumed_by_tx_id bigint
);


--
-- TOC entry 536 (class 1259 OID 387649)
-- Name: utxo_byron_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.utxo_byron_view AS
 SELECT tx_out.id,
    tx_out.tx_id,
    tx_out.index,
    tx_out.address,
    tx_out.address_has_script,
    tx_out.payment_cred,
    tx_out.stake_address_id,
    tx_out.value,
    tx_out.data_hash,
    tx_out.inline_datum_id,
    tx_out.reference_script_id,
    tx_out.consumed_by_tx_id
   FROM (public.tx_out
     LEFT JOIN public.tx_in ON (((tx_out.tx_id = tx_in.tx_out_id) AND ((tx_out.index)::smallint = (tx_in.tx_out_index)::smallint))))
  WHERE (tx_in.tx_in_id IS NULL);


--
-- TOC entry 537 (class 1259 OID 387654)
-- Name: utxo_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.utxo_view AS
 SELECT tx_out.id,
    tx_out.tx_id,
    tx_out.index,
    tx_out.address,
    tx_out.address_has_script,
    tx_out.payment_cred,
    tx_out.stake_address_id,
    tx_out.value,
    tx_out.data_hash,
    tx_out.inline_datum_id,
    tx_out.reference_script_id,
    tx_out.consumed_by_tx_id
   FROM (((public.tx_out
     LEFT JOIN public.tx_in ON (((tx_out.tx_id = tx_in.tx_out_id) AND ((tx_out.index)::smallint = (tx_in.tx_out_index)::smallint))))
     LEFT JOIN public.tx ON ((tx.id = tx_out.tx_id)))
     LEFT JOIN public.block ON ((tx.block_id = block.id)))
  WHERE ((tx_in.tx_in_id IS NULL) AND (block.epoch_no IS NOT NULL));


--
-- TOC entry 364 (class 1259 OID 17733)
-- Name: voting_anchor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voting_anchor (
    id bigint NOT NULL,
    url character varying NOT NULL,
    data_hash bytea NOT NULL,
    type public.anchortype NOT NULL,
    block_id bigint NOT NULL
);


--
-- TOC entry 372 (class 1259 OID 17771)
-- Name: voting_procedure; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.voting_procedure (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    index integer NOT NULL,
    gov_action_proposal_id bigint NOT NULL,
    voter_role public.voterrole NOT NULL,
    drep_voter bigint,
    pool_voter bigint,
    vote public.vote NOT NULL,
    voting_anchor_id bigint,
    committee_voter bigint,
    invalid bigint
);


--
-- TOC entry 305 (class 1259 OID 17085)
-- Name: withdrawal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.withdrawal (
    id bigint NOT NULL,
    addr_id bigint NOT NULL,
    amount public.lovelace NOT NULL,
    redeemer_id bigint,
    tx_id bigint NOT NULL
);


--
-- TOC entry 571 (class 1259 OID 391951)
-- Name: ActiveStake; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."ActiveStake" AS
 SELECT stake_address.view AS address,
    epoch_stake.amount,
    epoch_stake.epoch_no AS "epochNo",
    epoch_stake.id,
    pool_hash.hash_raw AS "stakePoolHash",
    pool_hash.view AS "stakePoolId"
   FROM ((public.epoch_stake
     JOIN public.pool_hash ON ((pool_hash.id = epoch_stake.pool_id)))
     JOIN public.stake_address ON ((epoch_stake.addr_id = stake_address.id)));


--
-- TOC entry 549 (class 1259 OID 391856)
-- Name: AdaPots; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."AdaPots" AS
 SELECT epoch_no AS "epochNo",
    deposits_stake,
    deposits_drep,
    deposits_proposal AS fees,
    reserves,
    rewards,
    slot_no AS "slotNo",
    treasury,
    utxo
   FROM public.ada_pots;


--
-- TOC entry 381 (class 1259 OID 17845)
-- Name: Asset; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Asset" (
    "assetId" bytea NOT NULL,
    "assetName" bytea,
    decimals integer,
    description character varying,
    fingerprint character(44),
    "firstAppearedInSlot" integer,
    logo character varying,
    "metadataHash" character(40),
    name character varying,
    "policyId" bytea,
    ticker character varying(9),
    url character varying
);


--
-- TOC entry 550 (class 1259 OID 391860)
-- Name: Block; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Block" AS
 SELECT (COALESCE(( SELECT sum((tx.fee)::bigint) AS sum
           FROM public.tx
          WHERE (tx.block_id = block.id)), (0)::numeric))::bigint AS fees,
    block.hash,
    block.block_no AS number,
    block.op_cert AS "opCert",
    previous_block.hash AS "previousBlockHash",
    next_block.hash AS "nextBlockHash",
    jsonb_build_object('major', block.proto_major, 'minor', block.proto_minor) AS "protocolVersion",
    block.size,
    block.tx_count AS "transactionsCount",
    block.epoch_no AS "epochNo",
    block."time" AS "forgedAt",
    block.epoch_slot_no AS "slotInEpoch",
    block.slot_no AS "slotNo",
    slot_leader.id AS slot_leader_id,
    slot_leader.pool_hash_id,
    block.vrf_key AS "vrfKey"
   FROM (((public.block
     LEFT JOIN public.block previous_block ON ((block.previous_id = previous_block.id)))
     LEFT JOIN public.block next_block ON ((next_block.previous_id = block.id)))
     LEFT JOIN public.slot_leader ON ((block.slot_leader_id = slot_leader.id)));


--
-- TOC entry 551 (class 1259 OID 391865)
-- Name: Cardano; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Cardano" AS
 SELECT block_no AS "tipBlockNo",
    epoch_no AS "currentEpochNo"
   FROM public.block
  WHERE (block_no IS NOT NULL)
  ORDER BY id DESC
 LIMIT 1;


--
-- TOC entry 552 (class 1259 OID 391869)
-- Name: CollateralInput; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."CollateralInput" AS
 SELECT source_tx_out.address,
    source_tx_out.value,
    tx.hash AS "txHash",
    source_tx.hash AS "sourceTxHash",
    collateral_tx_in.tx_out_index AS "sourceTxIndex",
    source_tx_out.id AS source_tx_out_id
   FROM (((public.tx
     JOIN public.collateral_tx_in ON ((collateral_tx_in.tx_in_id = tx.id)))
     JOIN public.tx_out source_tx_out ON (((collateral_tx_in.tx_out_id = source_tx_out.tx_id) AND ((collateral_tx_in.tx_out_index)::smallint = (source_tx_out.index)::smallint))))
     JOIN public.tx source_tx ON ((source_tx_out.tx_id = source_tx.id)));


--
-- TOC entry 553 (class 1259 OID 391874)
-- Name: CollateralOutput; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."CollateralOutput" AS
 SELECT collateral_tx_out.address,
    collateral_tx_out.address_has_script AS "addressHasScript",
    collateral_tx_out.value,
    tx.hash AS "txHash",
    collateral_tx_out.id,
    collateral_tx_out.index,
    collateral_tx_out.inline_datum_id,
    collateral_tx_out.reference_script_id,
    collateral_tx_out.payment_cred AS "paymentCredential"
   FROM (public.tx
     JOIN public.collateral_tx_out ON ((tx.id = collateral_tx_out.tx_id)));


--
-- TOC entry 557 (class 1259 OID 391892)
-- Name: Datum; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Datum" AS
 SELECT bytes,
    hash,
    id,
    tx_id,
    value
   FROM public.datum;


--
-- TOC entry 554 (class 1259 OID 391879)
-- Name: Delegation; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Delegation" AS
 SELECT delegation.id,
    stake_address.view AS address,
    delegation.redeemer_id AS "redeemerId",
    delegation.tx_id,
    delegation.pool_hash_id
   FROM (public.delegation
     JOIN public.stake_address ON ((delegation.addr_id = stake_address.id)));


--
-- TOC entry 555 (class 1259 OID 391883)
-- Name: DelegationVote; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."DelegationVote" AS
 SELECT delegation_vote.id,
    stake_address.view AS address,
    delegation_vote.redeemer_id AS "redeemerId",
    delegation_vote.tx_id,
    delegation_vote.drep_hash_id
   FROM (public.delegation_vote
     JOIN public.stake_address ON ((delegation_vote.addr_id = stake_address.id)));


--
-- TOC entry 570 (class 1259 OID 391947)
-- Name: DrepRegistration; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."DrepRegistration" AS
 SELECT drep_registration.id,
    drep_hash.view AS "DRepId",
    drep_registration.tx_id,
    drep_registration.deposit,
    drep_registration.voting_anchor_id
   FROM (public.drep_registration
     JOIN public.drep_hash ON ((drep_registration.drep_hash_id = drep_hash.id)));


--
-- TOC entry 556 (class 1259 OID 391887)
-- Name: Epoch; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Epoch" AS
 SELECT epoch.fees,
    epoch.out_sum AS output,
    epoch.no AS number,
    epoch_param.nonce,
    epoch.tx_count AS "transactionsCount",
    epoch.start_time AS "startedAt",
    epoch.end_time AS "lastBlockTime",
    epoch.blk_count AS "blocksCount"
   FROM (public.epoch
     LEFT JOIN public.epoch_param ON (((epoch.no)::integer = (epoch_param.epoch_no)::integer)));


--
-- TOC entry 559 (class 1259 OID 391900)
-- Name: ProtocolParams; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."ProtocolParams" AS
 SELECT epoch_param.influence AS a0,
    epoch_param.coins_per_utxo_size AS "coinsPerUtxoByte",
    epoch_param.collateral_percent AS "collateralPercent",
    cost_model.costs AS "costModels",
    epoch_param.decentralisation AS "decentralisationParam",
    epoch_param.max_collateral_inputs AS "maxCollateralInputs",
    epoch_param.max_epoch AS "eMax",
    epoch_param.epoch_no,
    epoch_param.extra_entropy AS "extraEntropy",
    epoch_param.key_deposit AS "keyDeposit",
    epoch_param.max_block_size AS "maxBlockBodySize",
    epoch_param.max_block_ex_mem AS "maxBlockExMem",
    epoch_param.max_block_ex_steps AS "maxBlockExSteps",
    epoch_param.max_bh_size AS "maxBlockHeaderSize",
    epoch_param.max_tx_ex_mem AS "maxTxExMem",
    epoch_param.max_tx_ex_steps AS "maxTxExSteps",
    epoch_param.max_tx_size AS "maxTxSize",
    epoch_param.max_val_size AS "maxValSize",
    epoch_param.min_fee_a AS "minFeeA",
    epoch_param.min_fee_b AS "minFeeB",
    epoch_param.min_pool_cost AS "minPoolCost",
    epoch_param.min_utxo_value AS "minUTxOValue",
    epoch_param.optimal_pool_count AS "nOpt",
    epoch_param.pool_deposit AS "poolDeposit",
    epoch_param.price_mem AS "priceMem",
    epoch_param.price_step AS "priceStep",
    jsonb_build_object('major', epoch_param.protocol_major, 'minor', epoch_param.protocol_major) AS "protocolVersion",
    epoch_param.monetary_expand_rate AS rho,
    epoch_param.treasury_growth_rate AS tau
   FROM (public.epoch_param
     JOIN public.cost_model ON ((epoch_param.cost_model_id = cost_model.id)));


--
-- TOC entry 560 (class 1259 OID 391905)
-- Name: Redeemer; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Redeemer" AS
 SELECT fee,
    id,
    index,
    purpose,
    script_hash AS "scriptHash",
    tx_id AS "txId",
    unit_mem AS "unitMem",
    unit_steps AS "unitSteps",
    redeemer_data_id AS redeemer_datum_id
   FROM public.redeemer;


--
-- TOC entry 558 (class 1259 OID 391896)
-- Name: RedeemerDatum; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."RedeemerDatum" AS
 SELECT bytes,
    hash,
    id,
    tx_id,
    value
   FROM public.redeemer_data;


--
-- TOC entry 561 (class 1259 OID 391909)
-- Name: ReferenceInput; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."ReferenceInput" AS
 SELECT source_tx_out.address,
    source_tx_out.value,
    tx.hash AS "txHash",
    source_tx.hash AS "sourceTxHash",
    reference_tx_in.tx_out_index AS "sourceTxIndex",
    source_tx_out.id AS source_tx_out_id
   FROM (((public.tx
     JOIN public.reference_tx_in ON ((reference_tx_in.tx_in_id = tx.id)))
     JOIN public.tx_out source_tx_out ON (((reference_tx_in.tx_out_id = source_tx_out.tx_id) AND ((reference_tx_in.tx_out_index)::smallint = (source_tx_out.index)::smallint))))
     JOIN public.tx source_tx ON ((source_tx_out.tx_id = source_tx.id)));


--
-- TOC entry 562 (class 1259 OID 391914)
-- Name: Reward; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Reward" AS
 SELECT reward.amount,
    stake_address.view AS address,
    reward.earned_epoch AS "earnedInEpochNo",
    reward.pool_id AS pool_hash_id,
    reward.spendable_epoch AS "receivedInEpochNo",
    reward.type
   FROM (public.reward
     JOIN public.stake_address ON ((reward.addr_id = stake_address.id)));


--
-- TOC entry 563 (class 1259 OID 391918)
-- Name: Script; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Script" AS
 SELECT hash,
    id,
    serialised_size AS "serialisedSize",
    type,
    tx_id AS "txId"
   FROM public.script;


--
-- TOC entry 564 (class 1259 OID 391922)
-- Name: SlotLeader; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."SlotLeader" AS
 SELECT hash,
    id,
    description,
    pool_hash_id
   FROM public.slot_leader;


--
-- TOC entry 565 (class 1259 OID 391926)
-- Name: StakeDeregistration; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."StakeDeregistration" AS
 SELECT stake_deregistration.id,
    stake_address.view AS address,
    stake_deregistration.redeemer_id AS "redeemerId",
    stake_deregistration.tx_id
   FROM (public.stake_deregistration
     JOIN public.stake_address ON ((stake_deregistration.addr_id = stake_address.id)));


--
-- TOC entry 566 (class 1259 OID 391930)
-- Name: StakePool; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."StakePool" AS
 WITH latest_block_times AS (
         SELECT pool_1.hash_id,
            max(block_1."time") AS blocktime
           FROM ((public.pool_update pool_1
             JOIN public.tx tx_1 ON ((pool_1.registered_tx_id = tx_1.id)))
             JOIN public.block block_1 ON ((tx_1.block_id = block_1.id)))
          GROUP BY pool_1.hash_id
        )
 SELECT pool.fixed_cost AS "fixedCost",
    pool_hash.hash_raw AS hash,
    pool_hash.view AS id,
    pool.hash_id,
    pool.id AS update_id,
    pool.margin,
    pool_metadata_ref.hash AS "metadataHash",
    block.block_no AS "blockNo",
    pool.registered_tx_id AS updated_in_tx_id,
    pool.pledge,
    stake_address.view AS "rewardAddress",
    pool_metadata_ref.url,
    pool.deposit
   FROM ((((((public.pool_update pool
     LEFT JOIN public.pool_metadata_ref ON ((pool.meta_id = pool_metadata_ref.id)))
     JOIN public.tx ON ((pool.registered_tx_id = tx.id)))
     JOIN latest_block_times ON ((latest_block_times.hash_id = pool.hash_id)))
     JOIN public.block ON (((tx.block_id = block.id) AND (latest_block_times.blocktime = block."time"))))
     JOIN public.stake_address ON ((pool.reward_addr_id = stake_address.id)))
     JOIN public.pool_hash ON ((pool_hash.id = pool.hash_id)));


--
-- TOC entry 567 (class 1259 OID 391935)
-- Name: StakePoolOwner; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."StakePoolOwner" AS
 SELECT stake_address.hash_raw AS hash,
    pool_update.hash_id AS pool_hash_id
   FROM ((public.pool_owner
     JOIN public.stake_address ON ((stake_address.id = pool_owner.addr_id)))
     JOIN public.pool_update ON ((pool_owner.pool_update_id = pool_update.id)));


--
-- TOC entry 568 (class 1259 OID 391939)
-- Name: StakePoolRetirement; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."StakePoolRetirement" AS
 SELECT retiring_epoch AS "inEffectFrom",
    announced_tx_id AS tx_id,
    hash_id AS pool_hash_id
   FROM public.pool_retire;


--
-- TOC entry 569 (class 1259 OID 391943)
-- Name: StakeRegistration; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."StakeRegistration" AS
 SELECT stake_registration.id,
    stake_address.view AS address,
    stake_registration.tx_id,
    stake_registration.deposit
   FROM (public.stake_registration
     JOIN public.stake_address ON ((stake_registration.addr_id = stake_address.id)));


--
-- TOC entry 573 (class 1259 OID 391959)
-- Name: TokenInOutput; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."TokenInOutput" AS
 SELECT (concat(multi_asset.policy, "right"(concat('\', multi_asset.name), '-3'::integer)))::bytea AS "assetId",
    multi_asset.name AS "assetName",
    multi_asset.policy AS "policyId",
    ma_tx_out.quantity,
    ma_tx_out.tx_out_id
   FROM (public.ma_tx_out
     JOIN public.multi_asset ON ((ma_tx_out.ident = multi_asset.id)));


--
-- TOC entry 572 (class 1259 OID 391955)
-- Name: TokenMint; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."TokenMint" AS
 SELECT (concat(multi_asset.policy, "right"(concat('\', multi_asset.name), '-3'::integer)))::bytea AS "assetId",
    multi_asset.name AS "assetName",
    multi_asset.policy AS "policyId",
    ma_tx_mint.quantity,
    ma_tx_mint.tx_id
   FROM (public.ma_tx_mint
     JOIN public.multi_asset ON ((ma_tx_mint.ident = multi_asset.id)));


--
-- TOC entry 574 (class 1259 OID 391963)
-- Name: Transaction; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Transaction" AS
 SELECT block.hash AS "blockHash",
    tx.block_index AS "blockIndex",
    tx.deposit,
    COALESCE((tx.fee)::numeric, (0)::numeric) AS fee,
    tx.hash,
    tx.id,
    block."time" AS "includedAt",
    tx.invalid_before AS "invalidBefore",
    tx.invalid_hereafter AS "invalidHereafter",
    tx.script_size AS "scriptSize",
    tx.size,
    (COALESCE(( SELECT sum((tx_out.value)::numeric) AS sum
           FROM public.tx_out
          WHERE (tx_out.tx_id = tx.id)), (0)::numeric))::bigint AS "totalOutput",
    tx.valid_contract AS "validContract",
    tx.treasury_donation AS "treasuryDonation"
   FROM (public.tx
     JOIN public.block ON ((block.id = tx.block_id)));


--
-- TOC entry 575 (class 1259 OID 391968)
-- Name: TransactionInput; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."TransactionInput" AS
 SELECT source_tx_out.address,
    tx_in.redeemer_id AS "redeemerId",
    source_tx_out.value,
    tx.hash AS "txHash",
    source_tx.hash AS "sourceTxHash",
    tx_in.tx_out_index AS "sourceTxIndex",
    source_tx_out.id AS source_tx_out_id
   FROM (((public.tx
     JOIN public.tx_in ON ((tx_in.tx_in_id = tx.id)))
     JOIN public.tx_out source_tx_out ON (((tx_in.tx_out_id = source_tx_out.tx_id) AND ((tx_in.tx_out_index)::smallint = (source_tx_out.index)::smallint))))
     JOIN public.tx source_tx ON ((source_tx_out.tx_id = source_tx.id)));


--
-- TOC entry 576 (class 1259 OID 391973)
-- Name: TransactionOutput; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."TransactionOutput" AS
 SELECT tx_out.address,
    tx_out.address_has_script AS "addressHasScript",
    tx_out.value,
    tx.hash AS "txHash",
    tx_out.id,
    tx_out.index,
    tx_out.inline_datum_id,
    tx_out.reference_script_id,
    tx_out.payment_cred AS "paymentCredential"
   FROM (public.tx
     JOIN public.tx_out ON ((tx.id = tx_out.tx_id)));


--
-- TOC entry 577 (class 1259 OID 391978)
-- Name: Utxo; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Utxo" AS
 SELECT tx_out.address,
    tx_out.address_has_script AS "addressHasScript",
    tx_out.value,
    tx.hash AS "txHash",
    tx_out.id,
    tx_out.index,
    tx_out.inline_datum_id,
    tx_out.reference_script_id
   FROM ((public.tx
     JOIN public.tx_out ON ((tx.id = tx_out.tx_id)))
     LEFT JOIN public.tx_in ON (((tx_out.tx_id = tx_in.tx_out_id) AND ((tx_out.index)::smallint = (tx_in.tx_out_index)::smallint))))
  WHERE (tx_in.tx_in_id IS NULL);


--
-- TOC entry 578 (class 1259 OID 391983)
-- Name: Withdrawal; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public."Withdrawal" AS
 SELECT withdrawal.amount,
    withdrawal.id,
    stake_address.view AS address,
    withdrawal.redeemer_id AS "redeemerId",
    withdrawal.tx_id
   FROM (public.withdrawal
     JOIN public.stake_address ON ((withdrawal.addr_id = stake_address.id)));


--
-- TOC entry 283 (class 1259 OID 16857)
-- Name: ada_pots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ada_pots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5586 (class 0 OID 0)
-- Dependencies: 283
-- Name: ada_pots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ada_pots_id_seq OWNED BY public.ada_pots.id;


--
-- TOC entry 263 (class 1259 OID 16681)
-- Name: block_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.block_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5587 (class 0 OID 0)
-- Dependencies: 263
-- Name: block_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.block_id_seq OWNED BY public.block.id;


--
-- TOC entry 277 (class 1259 OID 16816)
-- Name: collateral_tx_in_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collateral_tx_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5588 (class 0 OID 0)
-- Dependencies: 277
-- Name: collateral_tx_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collateral_tx_in_id_seq OWNED BY public.collateral_tx_in.id;


--
-- TOC entry 340 (class 1259 OID 17518)
-- Name: collateral_tx_out_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.collateral_tx_out_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5589 (class 0 OID 0)
-- Dependencies: 340
-- Name: collateral_tx_out_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.collateral_tx_out_id_seq OWNED BY public.collateral_tx_out.id;


--
-- TOC entry 405 (class 1259 OID 179701)
-- Name: committee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee (
    id bigint NOT NULL,
    gov_action_proposal_id bigint,
    quorum_numerator bigint NOT NULL,
    quorum_denominator bigint NOT NULL
);


--
-- TOC entry 359 (class 1259 OID 17716)
-- Name: committee_de_registration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_de_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5590 (class 0 OID 0)
-- Dependencies: 359
-- Name: committee_de_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_de_registration_id_seq OWNED BY public.committee_de_registration.id;


--
-- TOC entry 391 (class 1259 OID 179637)
-- Name: committee_hash; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_hash (
    id bigint NOT NULL,
    raw public.hash28type NOT NULL,
    has_script boolean NOT NULL
);


--
-- TOC entry 390 (class 1259 OID 179636)
-- Name: committee_hash_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_hash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5591 (class 0 OID 0)
-- Dependencies: 390
-- Name: committee_hash_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_hash_id_seq OWNED BY public.committee_hash.id;


--
-- TOC entry 404 (class 1259 OID 179700)
-- Name: committee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5592 (class 0 OID 0)
-- Dependencies: 404
-- Name: committee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_id_seq OWNED BY public.committee.id;


--
-- TOC entry 407 (class 1259 OID 179708)
-- Name: committee_member; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.committee_member (
    id bigint NOT NULL,
    committee_id bigint NOT NULL,
    committee_hash_id bigint NOT NULL,
    expiration_epoch public.word31type NOT NULL
);


--
-- TOC entry 406 (class 1259 OID 179707)
-- Name: committee_member_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5593 (class 0 OID 0)
-- Dependencies: 406
-- Name: committee_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_member_id_seq OWNED BY public.committee_member.id;


--
-- TOC entry 357 (class 1259 OID 17707)
-- Name: committee_registration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.committee_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5594 (class 0 OID 0)
-- Dependencies: 357
-- Name: committee_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.committee_registration_id_seq OWNED BY public.committee_registration.id;


--
-- TOC entry 379 (class 1259 OID 17810)
-- Name: constitution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.constitution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5595 (class 0 OID 0)
-- Dependencies: 379
-- Name: constitution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.constitution_id_seq OWNED BY public.constitution.id;


--
-- TOC entry 322 (class 1259 OID 17244)
-- Name: cost_model_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cost_model_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5596 (class 0 OID 0)
-- Dependencies: 322
-- Name: cost_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cost_model_id_seq OWNED BY public.cost_model.id;


--
-- TOC entry 271 (class 1259 OID 16755)
-- Name: datum_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.datum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5597 (class 0 OID 0)
-- Dependencies: 271
-- Name: datum_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.datum_id_seq OWNED BY public.datum.id;


--
-- TOC entry 299 (class 1259 OID 17020)
-- Name: delegation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delegation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5598 (class 0 OID 0)
-- Dependencies: 299
-- Name: delegation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delegation_id_seq OWNED BY public.delegation.id;


--
-- TOC entry 355 (class 1259 OID 17700)
-- Name: delegation_vote_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delegation_vote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5599 (class 0 OID 0)
-- Dependencies: 355
-- Name: delegation_vote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delegation_vote_id_seq OWNED BY public.delegation_vote.id;


--
-- TOC entry 336 (class 1259 OID 17399)
-- Name: delisted_pool_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.delisted_pool_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5600 (class 0 OID 0)
-- Dependencies: 336
-- Name: delisted_pool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.delisted_pool_id_seq OWNED BY public.delisted_pool.id;


--
-- TOC entry 373 (class 1259 OID 17779)
-- Name: drep_distr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drep_distr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5601 (class 0 OID 0)
-- Dependencies: 373
-- Name: drep_distr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drep_distr_id_seq OWNED BY public.drep_distr.id;


--
-- TOC entry 353 (class 1259 OID 17689)
-- Name: drep_hash_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drep_hash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5602 (class 0 OID 0)
-- Dependencies: 353
-- Name: drep_hash_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drep_hash_id_seq OWNED BY public.drep_hash.id;


--
-- TOC entry 361 (class 1259 OID 17725)
-- Name: drep_registration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drep_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5603 (class 0 OID 0)
-- Dependencies: 361
-- Name: drep_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drep_registration_id_seq OWNED BY public.drep_registration.id;


--
-- TOC entry 281 (class 1259 OID 16846)
-- Name: epoch_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epoch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5604 (class 0 OID 0)
-- Dependencies: 281
-- Name: epoch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epoch_id_seq OWNED BY public.epoch.id;


--
-- TOC entry 326 (class 1259 OID 17281)
-- Name: epoch_param_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epoch_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5605 (class 0 OID 0)
-- Dependencies: 326
-- Name: epoch_param_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epoch_param_id_seq OWNED BY public.epoch_param.id;


--
-- TOC entry 306 (class 1259 OID 17110)
-- Name: epoch_stake_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epoch_stake_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5606 (class 0 OID 0)
-- Dependencies: 306
-- Name: epoch_stake_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epoch_stake_id_seq OWNED BY public.epoch_stake.id;


--
-- TOC entry 348 (class 1259 OID 17647)
-- Name: epoch_stake_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epoch_stake_progress_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5607 (class 0 OID 0)
-- Dependencies: 348
-- Name: epoch_stake_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epoch_stake_progress_id_seq OWNED BY public.epoch_stake_progress.id;


--
-- TOC entry 399 (class 1259 OID 179675)
-- Name: epoch_state; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epoch_state (
    id bigint NOT NULL,
    committee_id bigint,
    no_confidence_id bigint,
    constitution_id bigint,
    epoch_no public.word31type NOT NULL
);


--
-- TOC entry 398 (class 1259 OID 179674)
-- Name: epoch_state_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epoch_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5608 (class 0 OID 0)
-- Dependencies: 398
-- Name: epoch_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epoch_state_id_seq OWNED BY public.epoch_state.id;


--
-- TOC entry 314 (class 1259 OID 17187)
-- Name: epoch_sync_time_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epoch_sync_time_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5609 (class 0 OID 0)
-- Dependencies: 314
-- Name: epoch_sync_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epoch_sync_time_id_seq OWNED BY public.epoch_sync_time.id;


--
-- TOC entry 413 (class 1259 OID 179744)
-- Name: event_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_info (
    id bigint NOT NULL,
    tx_id bigint,
    epoch public.word31type NOT NULL,
    type character varying NOT NULL,
    explanation character varying
);


--
-- TOC entry 412 (class 1259 OID 179743)
-- Name: event_info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5610 (class 0 OID 0)
-- Dependencies: 412
-- Name: event_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_info_id_seq OWNED BY public.event_info.id;


--
-- TOC entry 338 (class 1259 OID 17419)
-- Name: extra_key_witness_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.extra_key_witness_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5611 (class 0 OID 0)
-- Dependencies: 338
-- Name: extra_key_witness_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.extra_key_witness_id_seq OWNED BY public.extra_key_witness.id;


--
-- TOC entry 350 (class 1259 OID 17656)
-- Name: extra_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.extra_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5612 (class 0 OID 0)
-- Dependencies: 350
-- Name: extra_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.extra_migrations_id_seq OWNED BY public.extra_migrations.id;


--
-- TOC entry 365 (class 1259 OID 17743)
-- Name: gov_action_proposal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gov_action_proposal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5613 (class 0 OID 0)
-- Dependencies: 365
-- Name: gov_action_proposal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gov_action_proposal_id_seq OWNED BY public.gov_action_proposal.id;


--
-- TOC entry 316 (class 1259 OID 17196)
-- Name: ma_tx_mint_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ma_tx_mint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5614 (class 0 OID 0)
-- Dependencies: 316
-- Name: ma_tx_mint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ma_tx_mint_id_seq OWNED BY public.ma_tx_mint.id;


--
-- TOC entry 318 (class 1259 OID 17212)
-- Name: ma_tx_out_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ma_tx_out_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5615 (class 0 OID 0)
-- Dependencies: 318
-- Name: ma_tx_out_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ma_tx_out_id_seq OWNED BY public.ma_tx_out.id;


--
-- TOC entry 279 (class 1259 OID 16835)
-- Name: meta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5616 (class 0 OID 0)
-- Dependencies: 279
-- Name: meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meta_id_seq OWNED BY public.meta.id;


--
-- TOC entry 334 (class 1259 OID 17372)
-- Name: multi_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.multi_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5617 (class 0 OID 0)
-- Dependencies: 334
-- Name: multi_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.multi_asset_id_seq OWNED BY public.multi_asset.id;


--
-- TOC entry 369 (class 1259 OID 17761)
-- Name: new_committee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_committee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5618 (class 0 OID 0)
-- Dependencies: 369
-- Name: new_committee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_committee_id_seq OWNED BY public.new_committee.id;


--
-- TOC entry 328 (class 1259 OID 17302)
-- Name: off_chain_pool_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_pool_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5619 (class 0 OID 0)
-- Dependencies: 328
-- Name: off_chain_pool_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_pool_data_id_seq OWNED BY public.off_chain_pool_data.id;


--
-- TOC entry 330 (class 1259 OID 17323)
-- Name: off_chain_pool_fetch_error_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_pool_fetch_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5620 (class 0 OID 0)
-- Dependencies: 330
-- Name: off_chain_pool_fetch_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_pool_fetch_error_id_seq OWNED BY public.off_chain_pool_fetch_error.id;


--
-- TOC entry 393 (class 1259 OID 179648)
-- Name: off_chain_vote_author; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_author (
    id bigint NOT NULL,
    off_chain_vote_data_id bigint NOT NULL,
    name character varying,
    witness_algorithm character varying NOT NULL,
    public_key character varying NOT NULL,
    signature character varying NOT NULL,
    warning character varying
);


--
-- TOC entry 392 (class 1259 OID 179647)
-- Name: off_chain_vote_author_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5621 (class 0 OID 0)
-- Dependencies: 392
-- Name: off_chain_vote_author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_author_id_seq OWNED BY public.off_chain_vote_author.id;


--
-- TOC entry 375 (class 1259 OID 17788)
-- Name: off_chain_vote_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5622 (class 0 OID 0)
-- Dependencies: 375
-- Name: off_chain_vote_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_data_id_seq OWNED BY public.off_chain_vote_data.id;


--
-- TOC entry 403 (class 1259 OID 179692)
-- Name: off_chain_vote_drep_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_drep_data (
    id bigint NOT NULL,
    off_chain_vote_data_id bigint NOT NULL,
    payment_address character varying,
    given_name character varying NOT NULL,
    objectives character varying,
    motivations character varying,
    qualifications character varying,
    image_url character varying,
    image_hash character varying
);


--
-- TOC entry 402 (class 1259 OID 179691)
-- Name: off_chain_vote_drep_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_drep_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5623 (class 0 OID 0)
-- Dependencies: 402
-- Name: off_chain_vote_drep_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_drep_data_id_seq OWNED BY public.off_chain_vote_drep_data.id;


--
-- TOC entry 397 (class 1259 OID 179666)
-- Name: off_chain_vote_external_update; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_external_update (
    id bigint NOT NULL,
    off_chain_vote_data_id bigint NOT NULL,
    title character varying NOT NULL,
    uri character varying NOT NULL
);


--
-- TOC entry 396 (class 1259 OID 179665)
-- Name: off_chain_vote_external_update_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_external_update_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5624 (class 0 OID 0)
-- Dependencies: 396
-- Name: off_chain_vote_external_update_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_external_update_id_seq OWNED BY public.off_chain_vote_external_update.id;


--
-- TOC entry 377 (class 1259 OID 17799)
-- Name: off_chain_vote_fetch_error_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_fetch_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5625 (class 0 OID 0)
-- Dependencies: 377
-- Name: off_chain_vote_fetch_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_fetch_error_id_seq OWNED BY public.off_chain_vote_fetch_error.id;


--
-- TOC entry 401 (class 1259 OID 179683)
-- Name: off_chain_vote_gov_action_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_gov_action_data (
    id bigint NOT NULL,
    off_chain_vote_data_id bigint NOT NULL,
    title character varying NOT NULL,
    abstract character varying NOT NULL,
    motivation character varying NOT NULL,
    rationale character varying NOT NULL
);


--
-- TOC entry 400 (class 1259 OID 179682)
-- Name: off_chain_vote_gov_action_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_gov_action_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5626 (class 0 OID 0)
-- Dependencies: 400
-- Name: off_chain_vote_gov_action_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_gov_action_data_id_seq OWNED BY public.off_chain_vote_gov_action_data.id;


--
-- TOC entry 395 (class 1259 OID 179657)
-- Name: off_chain_vote_reference; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.off_chain_vote_reference (
    id bigint NOT NULL,
    off_chain_vote_data_id bigint NOT NULL,
    label character varying NOT NULL,
    uri character varying NOT NULL,
    hash_digest character varying,
    hash_algorithm character varying
);


--
-- TOC entry 394 (class 1259 OID 179656)
-- Name: off_chain_vote_reference_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.off_chain_vote_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5627 (class 0 OID 0)
-- Dependencies: 394
-- Name: off_chain_vote_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.off_chain_vote_reference_id_seq OWNED BY public.off_chain_vote_reference.id;


--
-- TOC entry 324 (class 1259 OID 17260)
-- Name: param_proposal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.param_proposal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5628 (class 0 OID 0)
-- Dependencies: 324
-- Name: param_proposal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.param_proposal_id_seq OWNED BY public.param_proposal.id;


--
-- TOC entry 259 (class 1259 OID 16654)
-- Name: pool_hash_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_hash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5629 (class 0 OID 0)
-- Dependencies: 259
-- Name: pool_hash_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_hash_id_seq OWNED BY public.pool_hash.id;


--
-- TOC entry 285 (class 1259 OID 16873)
-- Name: pool_metadata_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_metadata_ref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5630 (class 0 OID 0)
-- Dependencies: 285
-- Name: pool_metadata_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_metadata_ref_id_seq OWNED BY public.pool_metadata_ref.id;


--
-- TOC entry 289 (class 1259 OID 16920)
-- Name: pool_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_owner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5631 (class 0 OID 0)
-- Dependencies: 289
-- Name: pool_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_owner_id_seq OWNED BY public.pool_owner.id;


--
-- TOC entry 293 (class 1259 OID 16961)
-- Name: pool_relay_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_relay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5632 (class 0 OID 0)
-- Dependencies: 293
-- Name: pool_relay_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_relay_id_seq OWNED BY public.pool_relay.id;


--
-- TOC entry 291 (class 1259 OID 16942)
-- Name: pool_retire_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_retire_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5633 (class 0 OID 0)
-- Dependencies: 291
-- Name: pool_retire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_retire_id_seq OWNED BY public.pool_retire.id;


--
-- TOC entry 411 (class 1259 OID 179734)
-- Name: pool_stat; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_stat (
    id bigint NOT NULL,
    pool_hash_id bigint NOT NULL,
    epoch_no public.word31type NOT NULL,
    number_of_blocks public.word64type NOT NULL,
    number_of_delegators public.word64type NOT NULL,
    stake public.word64type NOT NULL,
    voting_power public.word64type
);


--
-- TOC entry 410 (class 1259 OID 179733)
-- Name: pool_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5634 (class 0 OID 0)
-- Dependencies: 410
-- Name: pool_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_stat_id_seq OWNED BY public.pool_stat.id;


--
-- TOC entry 287 (class 1259 OID 16894)
-- Name: pool_update_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_update_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5635 (class 0 OID 0)
-- Dependencies: 287
-- Name: pool_update_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_update_id_seq OWNED BY public.pool_update.id;


--
-- TOC entry 312 (class 1259 OID 17171)
-- Name: pot_transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pot_transfer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5636 (class 0 OID 0)
-- Dependencies: 312
-- Name: pot_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pot_transfer_id_seq OWNED BY public.pot_transfer.id;


--
-- TOC entry 344 (class 1259 OID 17560)
-- Name: redeemer_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.redeemer_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5637 (class 0 OID 0)
-- Dependencies: 344
-- Name: redeemer_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.redeemer_data_id_seq OWNED BY public.redeemer_data.id;


--
-- TOC entry 273 (class 1259 OID 16771)
-- Name: redeemer_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.redeemer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5638 (class 0 OID 0)
-- Dependencies: 273
-- Name: redeemer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.redeemer_id_seq OWNED BY public.redeemer.id;


--
-- TOC entry 342 (class 1259 OID 17539)
-- Name: reference_tx_in_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reference_tx_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5639 (class 0 OID 0)
-- Dependencies: 342
-- Name: reference_tx_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reference_tx_in_id_seq OWNED BY public.reference_tx_in.id;


--
-- TOC entry 310 (class 1259 OID 17150)
-- Name: reserve_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reserve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5640 (class 0 OID 0)
-- Dependencies: 310
-- Name: reserve_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reserve_id_seq OWNED BY public.reserve.id;


--
-- TOC entry 332 (class 1259 OID 17355)
-- Name: reserved_pool_ticker_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reserved_pool_ticker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5641 (class 0 OID 0)
-- Dependencies: 332
-- Name: reserved_pool_ticker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reserved_pool_ticker_id_seq OWNED BY public.reserved_pool_ticker.id;


--
-- TOC entry 346 (class 1259 OID 17635)
-- Name: reverse_index_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reverse_index_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5642 (class 0 OID 0)
-- Dependencies: 346
-- Name: reverse_index_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reverse_index_id_seq OWNED BY public.reverse_index.id;


--
-- TOC entry 352 (class 1259 OID 17666)
-- Name: reward_rest; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reward_rest (
    addr_id bigint NOT NULL,
    type public.rewardtype NOT NULL,
    amount public.lovelace NOT NULL,
    spendable_epoch bigint NOT NULL,
    earned_epoch bigint GENERATED ALWAYS AS (
CASE
    WHEN (spendable_epoch >= 1) THEN (spendable_epoch - 1)
    ELSE (0)::bigint
END) STORED NOT NULL
);


--
-- TOC entry 257 (class 1259 OID 16526)
-- Name: schema_version_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schema_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5643 (class 0 OID 0)
-- Dependencies: 257
-- Name: schema_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schema_version_id_seq OWNED BY public.schema_version.id;


--
-- TOC entry 320 (class 1259 OID 17228)
-- Name: script_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.script_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5644 (class 0 OID 0)
-- Dependencies: 320
-- Name: script_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.script_id_seq OWNED BY public.script.id;


--
-- TOC entry 261 (class 1259 OID 16665)
-- Name: slot_leader_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.slot_leader_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5645 (class 0 OID 0)
-- Dependencies: 261
-- Name: slot_leader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slot_leader_id_seq OWNED BY public.slot_leader.id;


--
-- TOC entry 267 (class 1259 OID 16718)
-- Name: stake_address_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stake_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5646 (class 0 OID 0)
-- Dependencies: 267
-- Name: stake_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stake_address_id_seq OWNED BY public.stake_address.id;


--
-- TOC entry 297 (class 1259 OID 16996)
-- Name: stake_deregistration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stake_deregistration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5647 (class 0 OID 0)
-- Dependencies: 297
-- Name: stake_deregistration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stake_deregistration_id_seq OWNED BY public.stake_deregistration.id;


--
-- TOC entry 295 (class 1259 OID 16977)
-- Name: stake_registration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stake_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5648 (class 0 OID 0)
-- Dependencies: 295
-- Name: stake_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stake_registration_id_seq OWNED BY public.stake_registration.id;


--
-- TOC entry 308 (class 1259 OID 17129)
-- Name: treasury_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.treasury_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5649 (class 0 OID 0)
-- Dependencies: 308
-- Name: treasury_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.treasury_id_seq OWNED BY public.treasury.id;


--
-- TOC entry 367 (class 1259 OID 17752)
-- Name: treasury_withdrawal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.treasury_withdrawal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5650 (class 0 OID 0)
-- Dependencies: 367
-- Name: treasury_withdrawal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.treasury_withdrawal_id_seq OWNED BY public.treasury_withdrawal.id;


--
-- TOC entry 409 (class 1259 OID 179721)
-- Name: tx_cbor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tx_cbor (
    id bigint NOT NULL,
    tx_id bigint NOT NULL,
    bytes bytea NOT NULL
);


--
-- TOC entry 408 (class 1259 OID 179720)
-- Name: tx_cbor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tx_cbor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5651 (class 0 OID 0)
-- Dependencies: 408
-- Name: tx_cbor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tx_cbor_id_seq OWNED BY public.tx_cbor.id;


--
-- TOC entry 265 (class 1259 OID 16702)
-- Name: tx_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tx_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5652 (class 0 OID 0)
-- Dependencies: 265
-- Name: tx_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tx_id_seq OWNED BY public.tx.id;


--
-- TOC entry 275 (class 1259 OID 16792)
-- Name: tx_in_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tx_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5653 (class 0 OID 0)
-- Dependencies: 275
-- Name: tx_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tx_in_id_seq OWNED BY public.tx_in.id;


--
-- TOC entry 302 (class 1259 OID 17050)
-- Name: tx_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tx_metadata (
    id bigint NOT NULL,
    key public.word64type NOT NULL,
    json jsonb,
    bytes bytea NOT NULL,
    tx_id bigint NOT NULL
);


--
-- TOC entry 301 (class 1259 OID 17049)
-- Name: tx_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tx_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5654 (class 0 OID 0)
-- Dependencies: 301
-- Name: tx_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tx_metadata_id_seq OWNED BY public.tx_metadata.id;


--
-- TOC entry 269 (class 1259 OID 16734)
-- Name: tx_out_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tx_out_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5655 (class 0 OID 0)
-- Dependencies: 269
-- Name: tx_out_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tx_out_id_seq OWNED BY public.tx_out.id;


--
-- TOC entry 363 (class 1259 OID 17732)
-- Name: voting_anchor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.voting_anchor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5656 (class 0 OID 0)
-- Dependencies: 363
-- Name: voting_anchor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.voting_anchor_id_seq OWNED BY public.voting_anchor.id;


--
-- TOC entry 371 (class 1259 OID 17770)
-- Name: voting_procedure_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.voting_procedure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5657 (class 0 OID 0)
-- Dependencies: 371
-- Name: voting_procedure_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.voting_procedure_id_seq OWNED BY public.voting_procedure.id;


--
-- TOC entry 304 (class 1259 OID 17084)
-- Name: withdrawal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.withdrawal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5658 (class 0 OID 0)
-- Dependencies: 304
-- Name: withdrawal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.withdrawal_id_seq OWNED BY public.withdrawal.id;


--
-- TOC entry 4846 (class 2604 OID 16861)
-- Name: ada_pots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ada_pots ALTER COLUMN id SET DEFAULT nextval('public.ada_pots_id_seq'::regclass);


--
-- TOC entry 4835 (class 2604 OID 16685)
-- Name: block id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block ALTER COLUMN id SET DEFAULT nextval('public.block_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 16820)
-- Name: collateral_tx_in id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collateral_tx_in ALTER COLUMN id SET DEFAULT nextval('public.collateral_tx_in_id_seq'::regclass);


--
-- TOC entry 4875 (class 2604 OID 17522)
-- Name: collateral_tx_out id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collateral_tx_out ALTER COLUMN id SET DEFAULT nextval('public.collateral_tx_out_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 179704)
-- Name: committee id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee ALTER COLUMN id SET DEFAULT nextval('public.committee_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 17720)
-- Name: committee_de_registration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_de_registration ALTER COLUMN id SET DEFAULT nextval('public.committee_de_registration_id_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 179640)
-- Name: committee_hash id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_hash ALTER COLUMN id SET DEFAULT nextval('public.committee_hash_id_seq'::regclass);


--
-- TOC entry 4904 (class 2604 OID 179711)
-- Name: committee_member id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_member ALTER COLUMN id SET DEFAULT nextval('public.committee_member_id_seq'::regclass);


--
-- TOC entry 4884 (class 2604 OID 17711)
-- Name: committee_registration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_registration ALTER COLUMN id SET DEFAULT nextval('public.committee_registration_id_seq'::regclass);


--
-- TOC entry 4895 (class 2604 OID 17814)
-- Name: constitution id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constitution ALTER COLUMN id SET DEFAULT nextval('public.constitution_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 17248)
-- Name: cost_model id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_model ALTER COLUMN id SET DEFAULT nextval('public.cost_model_id_seq'::regclass);


--
-- TOC entry 4840 (class 2604 OID 16759)
-- Name: datum id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datum ALTER COLUMN id SET DEFAULT nextval('public.datum_id_seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 17024)
-- Name: delegation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delegation ALTER COLUMN id SET DEFAULT nextval('public.delegation_id_seq'::regclass);


--
-- TOC entry 4883 (class 2604 OID 17704)
-- Name: delegation_vote id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delegation_vote ALTER COLUMN id SET DEFAULT nextval('public.delegation_vote_id_seq'::regclass);


--
-- TOC entry 4873 (class 2604 OID 17403)
-- Name: delisted_pool id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delisted_pool ALTER COLUMN id SET DEFAULT nextval('public.delisted_pool_id_seq'::regclass);


--
-- TOC entry 4892 (class 2604 OID 17783)
-- Name: drep_distr id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_distr ALTER COLUMN id SET DEFAULT nextval('public.drep_distr_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 17693)
-- Name: drep_hash id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_hash ALTER COLUMN id SET DEFAULT nextval('public.drep_hash_id_seq'::regclass);


--
-- TOC entry 4886 (class 2604 OID 17729)
-- Name: drep_registration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_registration ALTER COLUMN id SET DEFAULT nextval('public.drep_registration_id_seq'::regclass);


--
-- TOC entry 4845 (class 2604 OID 16850)
-- Name: epoch id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch ALTER COLUMN id SET DEFAULT nextval('public.epoch_id_seq'::regclass);


--
-- TOC entry 4868 (class 2604 OID 17285)
-- Name: epoch_param id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_param ALTER COLUMN id SET DEFAULT nextval('public.epoch_param_id_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 17114)
-- Name: epoch_stake id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_stake ALTER COLUMN id SET DEFAULT nextval('public.epoch_stake_id_seq'::regclass);


--
-- TOC entry 4879 (class 2604 OID 17651)
-- Name: epoch_stake_progress id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_stake_progress ALTER COLUMN id SET DEFAULT nextval('public.epoch_stake_progress_id_seq'::regclass);


--
-- TOC entry 4900 (class 2604 OID 179678)
-- Name: epoch_state id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_state ALTER COLUMN id SET DEFAULT nextval('public.epoch_state_id_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 17191)
-- Name: epoch_sync_time id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_sync_time ALTER COLUMN id SET DEFAULT nextval('public.epoch_sync_time_id_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 179747)
-- Name: event_info id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_info ALTER COLUMN id SET DEFAULT nextval('public.event_info_id_seq'::regclass);


--
-- TOC entry 4874 (class 2604 OID 17423)
-- Name: extra_key_witness id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extra_key_witness ALTER COLUMN id SET DEFAULT nextval('public.extra_key_witness_id_seq'::regclass);


--
-- TOC entry 4880 (class 2604 OID 17660)
-- Name: extra_migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extra_migrations ALTER COLUMN id SET DEFAULT nextval('public.extra_migrations_id_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 17747)
-- Name: gov_action_proposal id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gov_action_proposal ALTER COLUMN id SET DEFAULT nextval('public.gov_action_proposal_id_seq'::regclass);


--
-- TOC entry 4863 (class 2604 OID 17200)
-- Name: ma_tx_mint id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ma_tx_mint ALTER COLUMN id SET DEFAULT nextval('public.ma_tx_mint_id_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 17216)
-- Name: ma_tx_out id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ma_tx_out ALTER COLUMN id SET DEFAULT nextval('public.ma_tx_out_id_seq'::regclass);


--
-- TOC entry 4844 (class 2604 OID 16839)
-- Name: meta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta ALTER COLUMN id SET DEFAULT nextval('public.meta_id_seq'::regclass);


--
-- TOC entry 4872 (class 2604 OID 17376)
-- Name: multi_asset id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_asset ALTER COLUMN id SET DEFAULT nextval('public.multi_asset_id_seq'::regclass);


--
-- TOC entry 4890 (class 2604 OID 17765)
-- Name: new_committee id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_committee ALTER COLUMN id SET DEFAULT nextval('public.new_committee_id_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 17306)
-- Name: off_chain_pool_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_pool_data ALTER COLUMN id SET DEFAULT nextval('public.off_chain_pool_data_id_seq'::regclass);


--
-- TOC entry 4870 (class 2604 OID 17327)
-- Name: off_chain_pool_fetch_error id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_pool_fetch_error ALTER COLUMN id SET DEFAULT nextval('public.off_chain_pool_fetch_error_id_seq'::regclass);


--
-- TOC entry 4897 (class 2604 OID 179651)
-- Name: off_chain_vote_author id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_author ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_author_id_seq'::regclass);


--
-- TOC entry 4893 (class 2604 OID 17792)
-- Name: off_chain_vote_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_data ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_data_id_seq'::regclass);


--
-- TOC entry 4902 (class 2604 OID 179695)
-- Name: off_chain_vote_drep_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_drep_data ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_drep_data_id_seq'::regclass);


--
-- TOC entry 4899 (class 2604 OID 179669)
-- Name: off_chain_vote_external_update id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_external_update ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_external_update_id_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 17803)
-- Name: off_chain_vote_fetch_error id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_fetch_error ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_fetch_error_id_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 179686)
-- Name: off_chain_vote_gov_action_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_gov_action_data ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_gov_action_data_id_seq'::regclass);


--
-- TOC entry 4898 (class 2604 OID 179660)
-- Name: off_chain_vote_reference id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_reference ALTER COLUMN id SET DEFAULT nextval('public.off_chain_vote_reference_id_seq'::regclass);


--
-- TOC entry 4867 (class 2604 OID 17264)
-- Name: param_proposal id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.param_proposal ALTER COLUMN id SET DEFAULT nextval('public.param_proposal_id_seq'::regclass);


--
-- TOC entry 4833 (class 2604 OID 16658)
-- Name: pool_hash id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_hash ALTER COLUMN id SET DEFAULT nextval('public.pool_hash_id_seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 16877)
-- Name: pool_metadata_ref id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_metadata_ref ALTER COLUMN id SET DEFAULT nextval('public.pool_metadata_ref_id_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 16924)
-- Name: pool_owner id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_owner ALTER COLUMN id SET DEFAULT nextval('public.pool_owner_id_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 16965)
-- Name: pool_relay id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_relay ALTER COLUMN id SET DEFAULT nextval('public.pool_relay_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 16946)
-- Name: pool_retire id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_retire ALTER COLUMN id SET DEFAULT nextval('public.pool_retire_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 179737)
-- Name: pool_stat id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_stat ALTER COLUMN id SET DEFAULT nextval('public.pool_stat_id_seq'::regclass);


--
-- TOC entry 4848 (class 2604 OID 16898)
-- Name: pool_update id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_update ALTER COLUMN id SET DEFAULT nextval('public.pool_update_id_seq'::regclass);


--
-- TOC entry 4861 (class 2604 OID 17175)
-- Name: pot_transfer id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pot_transfer ALTER COLUMN id SET DEFAULT nextval('public.pot_transfer_id_seq'::regclass);


--
-- TOC entry 4841 (class 2604 OID 16775)
-- Name: redeemer id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeemer ALTER COLUMN id SET DEFAULT nextval('public.redeemer_id_seq'::regclass);


--
-- TOC entry 4877 (class 2604 OID 17564)
-- Name: redeemer_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeemer_data ALTER COLUMN id SET DEFAULT nextval('public.redeemer_data_id_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 17543)
-- Name: reference_tx_in id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_tx_in ALTER COLUMN id SET DEFAULT nextval('public.reference_tx_in_id_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 17154)
-- Name: reserve id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reserve ALTER COLUMN id SET DEFAULT nextval('public.reserve_id_seq'::regclass);


--
-- TOC entry 4871 (class 2604 OID 17359)
-- Name: reserved_pool_ticker id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reserved_pool_ticker ALTER COLUMN id SET DEFAULT nextval('public.reserved_pool_ticker_id_seq'::regclass);


--
-- TOC entry 4878 (class 2604 OID 17639)
-- Name: reverse_index id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reverse_index ALTER COLUMN id SET DEFAULT nextval('public.reverse_index_id_seq'::regclass);


--
-- TOC entry 4832 (class 2604 OID 16647)
-- Name: schema_version id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version ALTER COLUMN id SET DEFAULT nextval('public.schema_version_id_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 17232)
-- Name: script id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.script ALTER COLUMN id SET DEFAULT nextval('public.script_id_seq'::regclass);


--
-- TOC entry 4834 (class 2604 OID 16669)
-- Name: slot_leader id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slot_leader ALTER COLUMN id SET DEFAULT nextval('public.slot_leader_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 16722)
-- Name: stake_address id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_address ALTER COLUMN id SET DEFAULT nextval('public.stake_address_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 17000)
-- Name: stake_deregistration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_deregistration ALTER COLUMN id SET DEFAULT nextval('public.stake_deregistration_id_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 16981)
-- Name: stake_registration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_registration ALTER COLUMN id SET DEFAULT nextval('public.stake_registration_id_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 17133)
-- Name: treasury id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treasury ALTER COLUMN id SET DEFAULT nextval('public.treasury_id_seq'::regclass);


--
-- TOC entry 4889 (class 2604 OID 17756)
-- Name: treasury_withdrawal id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treasury_withdrawal ALTER COLUMN id SET DEFAULT nextval('public.treasury_withdrawal_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 16706)
-- Name: tx id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx ALTER COLUMN id SET DEFAULT nextval('public.tx_id_seq'::regclass);


--
-- TOC entry 4905 (class 2604 OID 179724)
-- Name: tx_cbor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_cbor ALTER COLUMN id SET DEFAULT nextval('public.tx_cbor_id_seq'::regclass);


--
-- TOC entry 4842 (class 2604 OID 16796)
-- Name: tx_in id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_in ALTER COLUMN id SET DEFAULT nextval('public.tx_in_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 17053)
-- Name: tx_metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_metadata ALTER COLUMN id SET DEFAULT nextval('public.tx_metadata_id_seq'::regclass);


--
-- TOC entry 4839 (class 2604 OID 16738)
-- Name: tx_out id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_out ALTER COLUMN id SET DEFAULT nextval('public.tx_out_id_seq'::regclass);


--
-- TOC entry 4887 (class 2604 OID 17736)
-- Name: voting_anchor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_anchor ALTER COLUMN id SET DEFAULT nextval('public.voting_anchor_id_seq'::regclass);


--
-- TOC entry 4891 (class 2604 OID 17774)
-- Name: voting_procedure id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_procedure ALTER COLUMN id SET DEFAULT nextval('public.voting_procedure_id_seq'::regclass);


--
-- TOC entry 4857 (class 2604 OID 17088)
-- Name: withdrawal id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal ALTER COLUMN id SET DEFAULT nextval('public.withdrawal_id_seq'::regclass);


--
-- TOC entry 5213 (class 2606 OID 17851)
-- Name: Asset Asset_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Asset"
    ADD CONSTRAINT "Asset_pkey" PRIMARY KEY ("assetId");


--
-- TOC entry 4989 (class 2606 OID 16865)
-- Name: ada_pots ada_pots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ada_pots
    ADD CONSTRAINT ada_pots_pkey PRIMARY KEY (id);


--
-- TOC entry 4922 (class 2606 OID 16689)
-- Name: block block_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT block_pkey PRIMARY KEY (id);


--
-- TOC entry 4975 (class 2606 OID 16822)
-- Name: collateral_tx_in collateral_tx_in_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collateral_tx_in
    ADD CONSTRAINT collateral_tx_in_pkey PRIMARY KEY (id);


--
-- TOC entry 5141 (class 2606 OID 17526)
-- Name: collateral_tx_out collateral_tx_out_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.collateral_tx_out
    ADD CONSTRAINT collateral_tx_out_pkey PRIMARY KEY (id);


--
-- TOC entry 5183 (class 2606 OID 17724)
-- Name: committee_de_registration committee_de_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_de_registration
    ADD CONSTRAINT committee_de_registration_pkey PRIMARY KEY (id);


--
-- TOC entry 5215 (class 2606 OID 179644)
-- Name: committee_hash committee_hash_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_hash
    ADD CONSTRAINT committee_hash_pkey PRIMARY KEY (id);


--
-- TOC entry 5233 (class 2606 OID 179713)
-- Name: committee_member committee_member_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_member
    ADD CONSTRAINT committee_member_pkey PRIMARY KEY (id);


--
-- TOC entry 5231 (class 2606 OID 179706)
-- Name: committee committee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee
    ADD CONSTRAINT committee_pkey PRIMARY KEY (id);


--
-- TOC entry 5181 (class 2606 OID 17715)
-- Name: committee_registration committee_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_registration
    ADD CONSTRAINT committee_registration_pkey PRIMARY KEY (id);


--
-- TOC entry 5211 (class 2606 OID 17818)
-- Name: constitution constitution_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constitution
    ADD CONSTRAINT constitution_pkey PRIMARY KEY (id);


--
-- TOC entry 5095 (class 2606 OID 17252)
-- Name: cost_model cost_model_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_model
    ADD CONSTRAINT cost_model_pkey PRIMARY KEY (id);


--
-- TOC entry 4957 (class 2606 OID 16763)
-- Name: datum datum_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datum
    ADD CONSTRAINT datum_pkey PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 17026)
-- Name: delegation delegation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delegation
    ADD CONSTRAINT delegation_pkey PRIMARY KEY (id);


--
-- TOC entry 5179 (class 2606 OID 17706)
-- Name: delegation_vote delegation_vote_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delegation_vote
    ADD CONSTRAINT delegation_vote_pkey PRIMARY KEY (id);


--
-- TOC entry 5132 (class 2606 OID 17407)
-- Name: delisted_pool delisted_pool_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delisted_pool
    ADD CONSTRAINT delisted_pool_pkey PRIMARY KEY (id);


--
-- TOC entry 5199 (class 2606 OID 17785)
-- Name: drep_distr drep_distr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_distr
    ADD CONSTRAINT drep_distr_pkey PRIMARY KEY (id);


--
-- TOC entry 5173 (class 2606 OID 17697)
-- Name: drep_hash drep_hash_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_hash
    ADD CONSTRAINT drep_hash_pkey PRIMARY KEY (id);


--
-- TOC entry 5185 (class 2606 OID 17731)
-- Name: drep_registration drep_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_registration
    ADD CONSTRAINT drep_registration_pkey PRIMARY KEY (id);


--
-- TOC entry 5104 (class 2606 OID 17289)
-- Name: epoch_param epoch_param_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_param
    ADD CONSTRAINT epoch_param_pkey PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 16854)
-- Name: epoch epoch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch
    ADD CONSTRAINT epoch_pkey PRIMARY KEY (id);


--
-- TOC entry 5054 (class 2606 OID 17118)
-- Name: epoch_stake epoch_stake_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_stake
    ADD CONSTRAINT epoch_stake_pkey PRIMARY KEY (id);


--
-- TOC entry 5160 (class 2606 OID 17653)
-- Name: epoch_stake_progress epoch_stake_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_stake_progress
    ADD CONSTRAINT epoch_stake_progress_pkey PRIMARY KEY (id);


--
-- TOC entry 5225 (class 2606 OID 179680)
-- Name: epoch_state epoch_state_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_state
    ADD CONSTRAINT epoch_state_pkey PRIMARY KEY (id);


--
-- TOC entry 5074 (class 2606 OID 17193)
-- Name: epoch_sync_time epoch_sync_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_sync_time
    ADD CONSTRAINT epoch_sync_time_pkey PRIMARY KEY (id);


--
-- TOC entry 5243 (class 2606 OID 179751)
-- Name: event_info event_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_info
    ADD CONSTRAINT event_info_pkey PRIMARY KEY (id);


--
-- TOC entry 5136 (class 2606 OID 17427)
-- Name: extra_key_witness extra_key_witness_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extra_key_witness
    ADD CONSTRAINT extra_key_witness_pkey PRIMARY KEY (id);


--
-- TOC entry 5164 (class 2606 OID 17664)
-- Name: extra_migrations extra_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.extra_migrations
    ADD CONSTRAINT extra_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 5191 (class 2606 OID 17751)
-- Name: gov_action_proposal gov_action_proposal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gov_action_proposal
    ADD CONSTRAINT gov_action_proposal_pkey PRIMARY KEY (id);


--
-- TOC entry 5080 (class 2606 OID 17204)
-- Name: ma_tx_mint ma_tx_mint_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ma_tx_mint
    ADD CONSTRAINT ma_tx_mint_pkey PRIMARY KEY (id);


--
-- TOC entry 5086 (class 2606 OID 17220)
-- Name: ma_tx_out ma_tx_out_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ma_tx_out
    ADD CONSTRAINT ma_tx_out_pkey PRIMARY KEY (id);


--
-- TOC entry 4980 (class 2606 OID 16843)
-- Name: meta meta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta
    ADD CONSTRAINT meta_pkey PRIMARY KEY (id);


--
-- TOC entry 5128 (class 2606 OID 17380)
-- Name: multi_asset multi_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_asset
    ADD CONSTRAINT multi_asset_pkey PRIMARY KEY (id);


--
-- TOC entry 5195 (class 2606 OID 17769)
-- Name: new_committee new_committee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_committee
    ADD CONSTRAINT new_committee_pkey PRIMARY KEY (id);


--
-- TOC entry 5110 (class 2606 OID 17310)
-- Name: off_chain_pool_data off_chain_pool_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_pool_data
    ADD CONSTRAINT off_chain_pool_data_pkey PRIMARY KEY (id);


--
-- TOC entry 5115 (class 2606 OID 17331)
-- Name: off_chain_pool_fetch_error off_chain_pool_fetch_error_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_pool_fetch_error
    ADD CONSTRAINT off_chain_pool_fetch_error_pkey PRIMARY KEY (id);


--
-- TOC entry 5219 (class 2606 OID 179655)
-- Name: off_chain_vote_author off_chain_vote_author_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_author
    ADD CONSTRAINT off_chain_vote_author_pkey PRIMARY KEY (id);


--
-- TOC entry 5203 (class 2606 OID 17796)
-- Name: off_chain_vote_data off_chain_vote_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_data
    ADD CONSTRAINT off_chain_vote_data_pkey PRIMARY KEY (id);


--
-- TOC entry 5229 (class 2606 OID 179699)
-- Name: off_chain_vote_drep_data off_chain_vote_drep_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_drep_data
    ADD CONSTRAINT off_chain_vote_drep_data_pkey PRIMARY KEY (id);


--
-- TOC entry 5223 (class 2606 OID 179673)
-- Name: off_chain_vote_external_update off_chain_vote_external_update_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_external_update
    ADD CONSTRAINT off_chain_vote_external_update_pkey PRIMARY KEY (id);


--
-- TOC entry 5207 (class 2606 OID 17807)
-- Name: off_chain_vote_fetch_error off_chain_vote_fetch_error_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_fetch_error
    ADD CONSTRAINT off_chain_vote_fetch_error_pkey PRIMARY KEY (id);


--
-- TOC entry 5227 (class 2606 OID 179690)
-- Name: off_chain_vote_gov_action_data off_chain_vote_gov_action_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_gov_action_data
    ADD CONSTRAINT off_chain_vote_gov_action_data_pkey PRIMARY KEY (id);


--
-- TOC entry 5221 (class 2606 OID 179664)
-- Name: off_chain_vote_reference off_chain_vote_reference_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_reference
    ADD CONSTRAINT off_chain_vote_reference_pkey PRIMARY KEY (id);


--
-- TOC entry 5101 (class 2606 OID 17268)
-- Name: param_proposal param_proposal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.param_proposal
    ADD CONSTRAINT param_proposal_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 16662)
-- Name: pool_hash pool_hash_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_hash
    ADD CONSTRAINT pool_hash_pkey PRIMARY KEY (id);


--
-- TOC entry 4994 (class 2606 OID 16881)
-- Name: pool_metadata_ref pool_metadata_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_metadata_ref
    ADD CONSTRAINT pool_metadata_ref_pkey PRIMARY KEY (id);


--
-- TOC entry 5004 (class 2606 OID 16926)
-- Name: pool_owner pool_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_owner
    ADD CONSTRAINT pool_owner_pkey PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 16969)
-- Name: pool_relay pool_relay_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_relay
    ADD CONSTRAINT pool_relay_pkey PRIMARY KEY (id);


--
-- TOC entry 5010 (class 2606 OID 16948)
-- Name: pool_retire pool_retire_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_retire
    ADD CONSTRAINT pool_retire_pkey PRIMARY KEY (id);


--
-- TOC entry 5240 (class 2606 OID 179741)
-- Name: pool_stat pool_stat_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_stat
    ADD CONSTRAINT pool_stat_pkey PRIMARY KEY (id);


--
-- TOC entry 5001 (class 2606 OID 16902)
-- Name: pool_update pool_update_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_update
    ADD CONSTRAINT pool_update_pkey PRIMARY KEY (id);


--
-- TOC entry 5071 (class 2606 OID 17179)
-- Name: pot_transfer pot_transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pot_transfer
    ADD CONSTRAINT pot_transfer_pkey PRIMARY KEY (id);


--
-- TOC entry 5153 (class 2606 OID 17568)
-- Name: redeemer_data redeemer_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeemer_data
    ADD CONSTRAINT redeemer_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4964 (class 2606 OID 16779)
-- Name: redeemer redeemer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeemer
    ADD CONSTRAINT redeemer_pkey PRIMARY KEY (id);


--
-- TOC entry 5148 (class 2606 OID 17545)
-- Name: reference_tx_in reference_tx_in_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_tx_in
    ADD CONSTRAINT reference_tx_in_pkey PRIMARY KEY (id);


--
-- TOC entry 5068 (class 2606 OID 17158)
-- Name: reserve reserve_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reserve
    ADD CONSTRAINT reserve_pkey PRIMARY KEY (id);


--
-- TOC entry 5120 (class 2606 OID 17363)
-- Name: reserved_pool_ticker reserved_pool_ticker_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reserved_pool_ticker
    ADD CONSTRAINT reserved_pool_ticker_pkey PRIMARY KEY (id);


--
-- TOC entry 5158 (class 2606 OID 17643)
-- Name: reverse_index reverse_index_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reverse_index
    ADD CONSTRAINT reverse_index_pkey PRIMARY KEY (id);


--
-- TOC entry 4909 (class 2606 OID 16649)
-- Name: schema_version schema_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pkey PRIMARY KEY (id);


--
-- TOC entry 5091 (class 2606 OID 17236)
-- Name: script script_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.script
    ADD CONSTRAINT script_pkey PRIMARY KEY (id);


--
-- TOC entry 4917 (class 2606 OID 16673)
-- Name: slot_leader slot_leader_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slot_leader
    ADD CONSTRAINT slot_leader_pkey PRIMARY KEY (id);


--
-- TOC entry 4941 (class 2606 OID 16726)
-- Name: stake_address stake_address_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_address
    ADD CONSTRAINT stake_address_pkey PRIMARY KEY (id);


--
-- TOC entry 5025 (class 2606 OID 17002)
-- Name: stake_deregistration stake_deregistration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_deregistration
    ADD CONSTRAINT stake_deregistration_pkey PRIMARY KEY (id);


--
-- TOC entry 5019 (class 2606 OID 16983)
-- Name: stake_registration stake_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_registration
    ADD CONSTRAINT stake_registration_pkey PRIMARY KEY (id);


--
-- TOC entry 5063 (class 2606 OID 17137)
-- Name: treasury treasury_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treasury
    ADD CONSTRAINT treasury_pkey PRIMARY KEY (id);


--
-- TOC entry 5193 (class 2606 OID 17760)
-- Name: treasury_withdrawal treasury_withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treasury_withdrawal
    ADD CONSTRAINT treasury_withdrawal_pkey PRIMARY KEY (id);


--
-- TOC entry 5237 (class 2606 OID 179728)
-- Name: tx_cbor tx_cbor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_cbor
    ADD CONSTRAINT tx_cbor_pkey PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 16798)
-- Name: tx_in tx_in_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_in
    ADD CONSTRAINT tx_in_pkey PRIMARY KEY (id);


--
-- TOC entry 5037 (class 2606 OID 17057)
-- Name: tx_metadata tx_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_metadata
    ADD CONSTRAINT tx_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 4951 (class 2606 OID 16742)
-- Name: tx_out tx_out_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_out
    ADD CONSTRAINT tx_out_pkey PRIMARY KEY (id);


--
-- TOC entry 4936 (class 2606 OID 16710)
-- Name: tx tx_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx
    ADD CONSTRAINT tx_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 2606 OID 16691)
-- Name: block unique_block; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.block
    ADD CONSTRAINT unique_block UNIQUE (hash);


--
-- TOC entry 5217 (class 2606 OID 179646)
-- Name: committee_hash unique_committee_hash; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_hash
    ADD CONSTRAINT unique_committee_hash UNIQUE (raw, has_script);


--
-- TOC entry 5097 (class 2606 OID 17612)
-- Name: cost_model unique_cost_model; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cost_model
    ADD CONSTRAINT unique_cost_model UNIQUE (hash);


--
-- TOC entry 4960 (class 2606 OID 17559)
-- Name: datum unique_datum; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datum
    ADD CONSTRAINT unique_datum UNIQUE (hash);


--
-- TOC entry 5134 (class 2606 OID 17409)
-- Name: delisted_pool unique_delisted_pool; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.delisted_pool
    ADD CONSTRAINT unique_delisted_pool UNIQUE (hash_raw);


--
-- TOC entry 5201 (class 2606 OID 17787)
-- Name: drep_distr unique_drep_distr; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_distr
    ADD CONSTRAINT unique_drep_distr UNIQUE (hash_id, epoch_no);


--
-- TOC entry 5176 (class 2606 OID 179632)
-- Name: drep_hash unique_drep_hash; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drep_hash
    ADD CONSTRAINT unique_drep_hash UNIQUE (raw, has_script);


--
-- TOC entry 4987 (class 2606 OID 16856)
-- Name: epoch unique_epoch; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch
    ADD CONSTRAINT unique_epoch UNIQUE (no);


--
-- TOC entry 5059 (class 2606 OID 160455)
-- Name: epoch_stake unique_epoch_stake; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_stake
    ADD CONSTRAINT unique_epoch_stake UNIQUE (epoch_no, addr_id, pool_id);


--
-- TOC entry 5162 (class 2606 OID 17655)
-- Name: epoch_stake_progress unique_epoch_stake_progress; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_stake_progress
    ADD CONSTRAINT unique_epoch_stake_progress UNIQUE (epoch_no);


--
-- TOC entry 5076 (class 2606 OID 17195)
-- Name: epoch_sync_time unique_epoch_sync_time; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epoch_sync_time
    ADD CONSTRAINT unique_epoch_sync_time UNIQUE (no);


--
-- TOC entry 4982 (class 2606 OID 16845)
-- Name: meta unique_meta; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta
    ADD CONSTRAINT unique_meta UNIQUE (start_time);


--
-- TOC entry 5130 (class 2606 OID 17382)
-- Name: multi_asset unique_multi_asset; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.multi_asset
    ADD CONSTRAINT unique_multi_asset UNIQUE (policy, name);


--
-- TOC entry 5112 (class 2606 OID 179753)
-- Name: off_chain_pool_data unique_off_chain_pool_data; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_pool_data
    ADD CONSTRAINT unique_off_chain_pool_data UNIQUE (pool_id, pmr_id);


--
-- TOC entry 5117 (class 2606 OID 17333)
-- Name: off_chain_pool_fetch_error unique_off_chain_pool_fetch_error; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_pool_fetch_error
    ADD CONSTRAINT unique_off_chain_pool_fetch_error UNIQUE (pool_id, fetch_time, retry_count);


--
-- TOC entry 5205 (class 2606 OID 17798)
-- Name: off_chain_vote_data unique_off_chain_vote_data; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_data
    ADD CONSTRAINT unique_off_chain_vote_data UNIQUE (voting_anchor_id, hash);


--
-- TOC entry 5209 (class 2606 OID 17809)
-- Name: off_chain_vote_fetch_error unique_off_chain_vote_fetch_error; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.off_chain_vote_fetch_error
    ADD CONSTRAINT unique_off_chain_vote_fetch_error UNIQUE (voting_anchor_id, retry_count);


--
-- TOC entry 4914 (class 2606 OID 16664)
-- Name: pool_hash unique_pool_hash; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_hash
    ADD CONSTRAINT unique_pool_hash UNIQUE (hash_raw);


--
-- TOC entry 5156 (class 2606 OID 17570)
-- Name: redeemer_data unique_redeemer_data; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redeemer_data
    ADD CONSTRAINT unique_redeemer_data UNIQUE (hash);


--
-- TOC entry 5122 (class 2606 OID 17365)
-- Name: reserved_pool_ticker unique_reserved_pool_ticker; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reserved_pool_ticker
    ADD CONSTRAINT unique_reserved_pool_ticker UNIQUE (name);


--
-- TOC entry 5045 (class 2606 OID 160457)
-- Name: reward unique_reward; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reward
    ADD CONSTRAINT unique_reward UNIQUE (addr_id, type, earned_epoch, pool_id);


--
-- TOC entry 5093 (class 2606 OID 17238)
-- Name: script unique_script; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.script
    ADD CONSTRAINT unique_script UNIQUE (hash);


--
-- TOC entry 4919 (class 2606 OID 16675)
-- Name: slot_leader unique_slot_leader; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slot_leader
    ADD CONSTRAINT unique_slot_leader UNIQUE (hash);


--
-- TOC entry 4943 (class 2606 OID 16728)
-- Name: stake_address unique_stake_address; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stake_address
    ADD CONSTRAINT unique_stake_address UNIQUE (hash_raw);


--
-- TOC entry 4938 (class 2606 OID 16712)
-- Name: tx unique_tx; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx
    ADD CONSTRAINT unique_tx UNIQUE (hash);


--
-- TOC entry 4954 (class 2606 OID 16744)
-- Name: tx_out unique_txout; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tx_out
    ADD CONSTRAINT unique_txout UNIQUE (tx_id, index);


--
-- TOC entry 5187 (class 2606 OID 179634)
-- Name: voting_anchor unique_voting_anchor; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_anchor
    ADD CONSTRAINT unique_voting_anchor UNIQUE (data_hash, url, type);


--
-- TOC entry 5189 (class 2606 OID 17740)
-- Name: voting_anchor voting_anchor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_anchor
    ADD CONSTRAINT voting_anchor_pkey PRIMARY KEY (id);


--
-- TOC entry 5197 (class 2606 OID 17778)
-- Name: voting_procedure voting_procedure_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.voting_procedure
    ADD CONSTRAINT voting_procedure_pkey PRIMARY KEY (id);


--
-- TOC entry 5051 (class 2606 OID 17092)
-- Name: withdrawal withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal
    ADD CONSTRAINT withdrawal_pkey PRIMARY KEY (id);


--
-- TOC entry 4920 (class 1259 OID 388460)
-- Name: bf_idx_block_hash_encoded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_block_hash_encoded ON public.block USING hash (encode((hash)::bytea, 'hex'::text));


--
-- TOC entry 5138 (class 1259 OID 388491)
-- Name: bf_idx_col_tx_out; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_col_tx_out ON public.collateral_tx_out USING btree (tx_id);


--
-- TOC entry 4973 (class 1259 OID 388488)
-- Name: bf_idx_collateral_tx_in_tx_in_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_collateral_tx_in_tx_in_id ON public.collateral_tx_in USING btree (tx_in_id);


--
-- TOC entry 4955 (class 1259 OID 388479)
-- Name: bf_idx_datum_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_datum_hash ON public.datum USING hash (encode((hash)::bytea, 'hex'::text));


--
-- TOC entry 5177 (class 1259 OID 388499)
-- Name: bf_idx_delegation_vote_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_delegation_vote_addr_id ON public.delegation_vote USING hash (addr_id);


--
-- TOC entry 5169 (class 1259 OID 388498)
-- Name: bf_idx_drep_hash_has_script; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_drep_hash_has_script ON public.drep_hash USING hash (has_script);


--
-- TOC entry 5170 (class 1259 OID 388496)
-- Name: bf_idx_drep_hash_raw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_drep_hash_raw ON public.drep_hash USING hash (raw);


--
-- TOC entry 5171 (class 1259 OID 388497)
-- Name: bf_idx_drep_hash_view; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_drep_hash_view ON public.drep_hash USING hash (view);


--
-- TOC entry 5077 (class 1259 OID 388492)
-- Name: bf_idx_ma_tx_mint_ident; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_ma_tx_mint_ident ON public.ma_tx_mint USING btree (ident);


--
-- TOC entry 5082 (class 1259 OID 388493)
-- Name: bf_idx_ma_tx_out_ident; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_ma_tx_out_ident ON public.ma_tx_out USING btree (ident);


--
-- TOC entry 5123 (class 1259 OID 388480)
-- Name: bf_idx_multi_asset_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_multi_asset_policy ON public.multi_asset USING hash (encode((policy)::bytea, 'hex'::text));


--
-- TOC entry 5124 (class 1259 OID 388481)
-- Name: bf_idx_multi_asset_policy_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_multi_asset_policy_name ON public.multi_asset USING hash (((encode((policy)::bytea, 'hex'::text) || encode((name)::bytea, 'hex'::text))));


--
-- TOC entry 4910 (class 1259 OID 388482)
-- Name: bf_idx_pool_hash_view; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_pool_hash_view ON public.pool_hash USING hash (view);


--
-- TOC entry 5151 (class 1259 OID 388483)
-- Name: bf_idx_redeemer_data_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_redeemer_data_hash ON public.redeemer_data USING hash (encode((hash)::bytea, 'hex'::text));


--
-- TOC entry 4961 (class 1259 OID 388489)
-- Name: bf_idx_redeemer_script_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_redeemer_script_hash ON public.redeemer USING hash (encode((script_hash)::bytea, 'hex'::text));


--
-- TOC entry 4962 (class 1259 OID 388490)
-- Name: bf_idx_redeemer_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_redeemer_tx_id ON public.redeemer USING btree (tx_id);


--
-- TOC entry 5145 (class 1259 OID 388487)
-- Name: bf_idx_reference_tx_in_tx_in_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_reference_tx_in_tx_in_id ON public.reference_tx_in USING btree (tx_in_id);


--
-- TOC entry 5165 (class 1259 OID 388494)
-- Name: bf_idx_reward_rest_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_reward_rest_addr_id ON public.reward_rest USING btree (addr_id);


--
-- TOC entry 5166 (class 1259 OID 388495)
-- Name: bf_idx_reward_rest_spendable_epoch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_reward_rest_spendable_epoch ON public.reward_rest USING btree (spendable_epoch);


--
-- TOC entry 5088 (class 1259 OID 388484)
-- Name: bf_idx_scripts_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_scripts_hash ON public.script USING hash (encode((hash)::bytea, 'hex'::text));


--
-- TOC entry 4932 (class 1259 OID 388485)
-- Name: bf_idx_tx_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bf_idx_tx_hash ON public.tx USING hash (encode((hash)::bytea, 'hex'::text));


--
-- TOC entry 5052 (class 1259 OID 388486)
-- Name: bf_u_idx_epoch_stake_epoch_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX bf_u_idx_epoch_stake_epoch_and_id ON public.epoch_stake USING btree (epoch_no, id);


--
-- TOC entry 5139 (class 1259 OID 160524)
-- Name: collateral_tx_out_inline_datum_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collateral_tx_out_inline_datum_id_idx ON public.collateral_tx_out USING btree (inline_datum_id);


--
-- TOC entry 5142 (class 1259 OID 160525)
-- Name: collateral_tx_out_reference_script_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collateral_tx_out_reference_script_id_idx ON public.collateral_tx_out USING btree (reference_script_id);


--
-- TOC entry 5143 (class 1259 OID 160523)
-- Name: collateral_tx_out_stake_address_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX collateral_tx_out_stake_address_id_idx ON public.collateral_tx_out USING btree (stake_address_id);


--
-- TOC entry 4923 (class 1259 OID 17831)
-- Name: idx_block_block_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_block_no ON public.block USING btree (block_no);


--
-- TOC entry 4924 (class 1259 OID 17832)
-- Name: idx_block_epoch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_epoch_no ON public.block USING btree (epoch_no);


--
-- TOC entry 4925 (class 1259 OID 17971)
-- Name: idx_block_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_hash ON public.block USING btree (hash);


--
-- TOC entry 4926 (class 1259 OID 17833)
-- Name: idx_block_previous_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_previous_id ON public.block USING btree (previous_id);


--
-- TOC entry 4927 (class 1259 OID 160470)
-- Name: idx_block_slot_leader_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_slot_leader_id ON public.block USING btree (slot_leader_id);


--
-- TOC entry 4928 (class 1259 OID 17830)
-- Name: idx_block_slot_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_slot_no ON public.block USING btree (slot_no);


--
-- TOC entry 4929 (class 1259 OID 160462)
-- Name: idx_block_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_block_time ON public.block USING btree ("time");


--
-- TOC entry 4976 (class 1259 OID 213055)
-- Name: idx_collateral_tx_in_tx_in_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_collateral_tx_in_tx_in_id ON public.collateral_tx_in USING btree (tx_in_id);


--
-- TOC entry 4977 (class 1259 OID 160511)
-- Name: idx_collateral_tx_in_tx_out_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_collateral_tx_in_tx_out_id ON public.collateral_tx_in USING btree (tx_out_id);


--
-- TOC entry 5234 (class 1259 OID 179770)
-- Name: idx_committee_member_committee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_committee_member_committee_id ON public.committee_member USING btree (committee_id);


--
-- TOC entry 4958 (class 1259 OID 160513)
-- Name: idx_datum_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_datum_tx_id ON public.datum USING btree (tx_id);


--
-- TOC entry 5029 (class 1259 OID 160501)
-- Name: idx_delegation_active_epoch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delegation_active_epoch_no ON public.delegation USING btree (active_epoch_no);


--
-- TOC entry 5030 (class 1259 OID 160488)
-- Name: idx_delegation_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delegation_addr_id ON public.delegation USING btree (addr_id);


--
-- TOC entry 5031 (class 1259 OID 160465)
-- Name: idx_delegation_pool_hash_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delegation_pool_hash_id ON public.delegation USING btree (pool_hash_id);


--
-- TOC entry 5032 (class 1259 OID 160507)
-- Name: idx_delegation_redeemer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delegation_redeemer_id ON public.delegation USING btree (redeemer_id);


--
-- TOC entry 5033 (class 1259 OID 160473)
-- Name: idx_delegation_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_delegation_tx_id ON public.delegation USING btree (tx_id);


--
-- TOC entry 5174 (class 1259 OID 213059)
-- Name: idx_drep_hash_raw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_drep_hash_raw ON public.drep_hash USING btree (raw);


--
-- TOC entry 4985 (class 1259 OID 160505)
-- Name: idx_epoch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_epoch_no ON public.epoch USING btree (no);


--
-- TOC entry 5105 (class 1259 OID 160471)
-- Name: idx_epoch_param_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_epoch_param_block_id ON public.epoch_param USING btree (block_id);


--
-- TOC entry 5106 (class 1259 OID 160516)
-- Name: idx_epoch_param_cost_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_epoch_param_cost_model_id ON public.epoch_param USING btree (cost_model_id);


--
-- TOC entry 5055 (class 1259 OID 160489)
-- Name: idx_epoch_stake_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_epoch_stake_addr_id ON public.epoch_stake USING btree (addr_id);


--
-- TOC entry 5056 (class 1259 OID 17836)
-- Name: idx_epoch_stake_epoch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_epoch_stake_epoch_no ON public.epoch_stake USING btree (epoch_no);


--
-- TOC entry 5057 (class 1259 OID 160466)
-- Name: idx_epoch_stake_pool_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_epoch_stake_pool_id ON public.epoch_stake USING btree (pool_id);


--
-- TOC entry 5137 (class 1259 OID 160514)
-- Name: idx_extra_key_witness_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_extra_key_witness_tx_id ON public.extra_key_witness USING btree (tx_id);


--
-- TOC entry 5078 (class 1259 OID 160474)
-- Name: idx_ma_tx_mint_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ma_tx_mint_tx_id ON public.ma_tx_mint USING btree (tx_id);


--
-- TOC entry 5083 (class 1259 OID 213054)
-- Name: idx_ma_tx_out_ident; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ma_tx_out_ident ON public.ma_tx_out USING btree (ident) INCLUDE (tx_out_id, quantity);


--
-- TOC entry 5084 (class 1259 OID 160497)
-- Name: idx_ma_tx_out_tx_out_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ma_tx_out_tx_out_id ON public.ma_tx_out USING btree (tx_out_id);


--
-- TOC entry 5125 (class 1259 OID 17972)
-- Name: idx_multi_asset_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_multi_asset_name ON public.multi_asset USING btree (name);


--
-- TOC entry 5126 (class 1259 OID 17973)
-- Name: idx_multi_asset_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_multi_asset_policy ON public.multi_asset USING btree (policy);


--
-- TOC entry 5108 (class 1259 OID 17839)
-- Name: idx_off_chain_pool_data_pmr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_off_chain_pool_data_pmr_id ON public.off_chain_pool_data USING btree (pmr_id);


--
-- TOC entry 5113 (class 1259 OID 17838)
-- Name: idx_off_chain_pool_fetch_error_pmr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_off_chain_pool_fetch_error_pmr_id ON public.off_chain_pool_fetch_error USING btree (pmr_id);


--
-- TOC entry 5098 (class 1259 OID 160515)
-- Name: idx_param_proposal_cost_model_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_param_proposal_cost_model_id ON public.param_proposal USING btree (cost_model_id);


--
-- TOC entry 5099 (class 1259 OID 160475)
-- Name: idx_param_proposal_registered_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_param_proposal_registered_tx_id ON public.param_proposal USING btree (registered_tx_id);


--
-- TOC entry 4991 (class 1259 OID 17837)
-- Name: idx_pool_metadata_ref_pool_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_metadata_ref_pool_id ON public.pool_metadata_ref USING btree (pool_id);


--
-- TOC entry 4992 (class 1259 OID 160476)
-- Name: idx_pool_metadata_ref_registered_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_metadata_ref_registered_tx_id ON public.pool_metadata_ref USING btree (registered_tx_id);


--
-- TOC entry 5012 (class 1259 OID 160499)
-- Name: idx_pool_relay_update_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_relay_update_id ON public.pool_relay USING btree (update_id);


--
-- TOC entry 5007 (class 1259 OID 160477)
-- Name: idx_pool_retire_announced_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_retire_announced_tx_id ON public.pool_retire USING btree (announced_tx_id);


--
-- TOC entry 5008 (class 1259 OID 160467)
-- Name: idx_pool_retire_hash_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_retire_hash_id ON public.pool_retire USING btree (hash_id);


--
-- TOC entry 4995 (class 1259 OID 160503)
-- Name: idx_pool_update_active_epoch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_update_active_epoch_no ON public.pool_update USING btree (active_epoch_no);


--
-- TOC entry 4996 (class 1259 OID 160464)
-- Name: idx_pool_update_hash_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_update_hash_id ON public.pool_update USING btree (hash_id);


--
-- TOC entry 4997 (class 1259 OID 160498)
-- Name: idx_pool_update_meta_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_update_meta_id ON public.pool_update USING btree (meta_id);


--
-- TOC entry 4998 (class 1259 OID 160478)
-- Name: idx_pool_update_registered_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_update_registered_tx_id ON public.pool_update USING btree (registered_tx_id);


--
-- TOC entry 4999 (class 1259 OID 160502)
-- Name: idx_pool_update_reward_addr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pool_update_reward_addr ON public.pool_update USING btree (reward_addr_id);


--
-- TOC entry 5146 (class 1259 OID 213056)
-- Name: idx_reference_tx_in_tx_in_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reference_tx_in_tx_in_id ON public.reference_tx_in USING btree (tx_in_id);


--
-- TOC entry 5065 (class 1259 OID 160490)
-- Name: idx_reserve_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reserve_addr_id ON public.reserve USING btree (addr_id);


--
-- TOC entry 5066 (class 1259 OID 160479)
-- Name: idx_reserve_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reserve_tx_id ON public.reserve USING btree (tx_id);


--
-- TOC entry 5118 (class 1259 OID 160510)
-- Name: idx_reserved_pool_ticker_pool_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reserved_pool_ticker_pool_hash ON public.reserved_pool_ticker USING btree (pool_hash);


--
-- TOC entry 5039 (class 1259 OID 160491)
-- Name: idx_reward_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_addr_id ON public.reward USING btree (addr_id);


--
-- TOC entry 5040 (class 1259 OID 160472)
-- Name: idx_reward_earned_epoch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_earned_epoch ON public.reward USING btree (earned_epoch);


--
-- TOC entry 5041 (class 1259 OID 160468)
-- Name: idx_reward_pool_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_pool_id ON public.reward USING btree (pool_id);


--
-- TOC entry 5167 (class 1259 OID 213060)
-- Name: idx_reward_rest_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_rest_addr_id ON public.reward_rest USING btree (addr_id);


--
-- TOC entry 5168 (class 1259 OID 213061)
-- Name: idx_reward_rest_spendable_epoch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_rest_spendable_epoch ON public.reward_rest USING btree (spendable_epoch);


--
-- TOC entry 5042 (class 1259 OID 17835)
-- Name: idx_reward_spendable_epoch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_spendable_epoch ON public.reward USING btree (spendable_epoch);


--
-- TOC entry 5043 (class 1259 OID 17974)
-- Name: idx_reward_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_reward_type ON public.reward USING btree (type);


--
-- TOC entry 5089 (class 1259 OID 160512)
-- Name: idx_script_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_script_tx_id ON public.script USING btree (tx_id);


--
-- TOC entry 4915 (class 1259 OID 160469)
-- Name: idx_slot_leader_pool_hash_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_slot_leader_pool_hash_id ON public.slot_leader USING btree (pool_hash_id);


--
-- TOC entry 4939 (class 1259 OID 160500)
-- Name: idx_stake_address_hash_raw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stake_address_hash_raw ON public.stake_address USING btree (hash_raw);


--
-- TOC entry 5021 (class 1259 OID 160492)
-- Name: idx_stake_deregistration_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stake_deregistration_addr_id ON public.stake_deregistration USING btree (addr_id);


--
-- TOC entry 5022 (class 1259 OID 160509)
-- Name: idx_stake_deregistration_redeemer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stake_deregistration_redeemer_id ON public.stake_deregistration USING btree (redeemer_id);


--
-- TOC entry 5023 (class 1259 OID 160480)
-- Name: idx_stake_deregistration_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stake_deregistration_tx_id ON public.stake_deregistration USING btree (tx_id);


--
-- TOC entry 5016 (class 1259 OID 160493)
-- Name: idx_stake_registration_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stake_registration_addr_id ON public.stake_registration USING btree (addr_id);


--
-- TOC entry 5017 (class 1259 OID 160481)
-- Name: idx_stake_registration_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_stake_registration_tx_id ON public.stake_registration USING btree (tx_id);


--
-- TOC entry 5060 (class 1259 OID 160494)
-- Name: idx_treasury_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_treasury_addr_id ON public.treasury USING btree (addr_id);


--
-- TOC entry 5061 (class 1259 OID 160482)
-- Name: idx_treasury_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_treasury_tx_id ON public.treasury USING btree (tx_id);


--
-- TOC entry 4933 (class 1259 OID 17834)
-- Name: idx_tx_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_block_id ON public.tx USING btree (block_id);


--
-- TOC entry 5235 (class 1259 OID 212890)
-- Name: idx_tx_cbor_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_cbor_tx_id ON public.tx_cbor USING btree (tx_id);


--
-- TOC entry 4934 (class 1259 OID 17975)
-- Name: idx_tx_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_hash ON public.tx USING btree (hash);


--
-- TOC entry 4967 (class 1259 OID 17976)
-- Name: idx_tx_in_consuming_tx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_in_consuming_tx ON public.tx_in USING btree (tx_out_id);


--
-- TOC entry 4968 (class 1259 OID 160506)
-- Name: idx_tx_in_redeemer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_in_redeemer_id ON public.tx_in USING btree (redeemer_id);


--
-- TOC entry 4969 (class 1259 OID 160483)
-- Name: idx_tx_in_tx_in_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_in_tx_in_id ON public.tx_in USING btree (tx_in_id);


--
-- TOC entry 4970 (class 1259 OID 160484)
-- Name: idx_tx_in_tx_out_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_in_tx_out_id ON public.tx_in USING btree (tx_out_id);


--
-- TOC entry 5035 (class 1259 OID 160485)
-- Name: idx_tx_metadata_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_metadata_tx_id ON public.tx_metadata USING btree (tx_id);


--
-- TOC entry 4944 (class 1259 OID 160459)
-- Name: idx_tx_out_address; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_out_address ON public.tx_out USING hash (address);


--
-- TOC entry 4945 (class 1259 OID 389199)
-- Name: idx_tx_out_consumed_by_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_out_consumed_by_tx_id ON public.tx_out USING btree (consumed_by_tx_id);


--
-- TOC entry 4946 (class 1259 OID 160463)
-- Name: idx_tx_out_payment_cred; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_out_payment_cred ON public.tx_out USING btree (payment_cred);


--
-- TOC entry 4947 (class 1259 OID 160495)
-- Name: idx_tx_out_stake_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_out_stake_address_id ON public.tx_out USING btree (stake_address_id);


--
-- TOC entry 4948 (class 1259 OID 160486)
-- Name: idx_tx_out_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tx_out_tx_id ON public.tx_out USING btree (tx_id);


--
-- TOC entry 5046 (class 1259 OID 160496)
-- Name: idx_withdrawal_addr_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_withdrawal_addr_id ON public.withdrawal USING btree (addr_id);


--
-- TOC entry 5047 (class 1259 OID 160508)
-- Name: idx_withdrawal_redeemer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_withdrawal_redeemer_id ON public.withdrawal USING btree (redeemer_id);


--
-- TOC entry 5048 (class 1259 OID 160487)
-- Name: idx_withdrawal_tx_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_withdrawal_tx_id ON public.withdrawal USING btree (tx_id);


--
-- TOC entry 5005 (class 1259 OID 160520)
-- Name: pool_owner_pool_update_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pool_owner_pool_update_id_idx ON public.pool_owner USING btree (pool_update_id);


--
-- TOC entry 5238 (class 1259 OID 213058)
-- Name: pool_stat_epoch_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pool_stat_epoch_no ON public.pool_stat USING btree (epoch_no);


--
-- TOC entry 5241 (class 1259 OID 213057)
-- Name: pool_stat_pool_hash_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pool_stat_pool_hash_id ON public.pool_stat USING btree (pool_hash_id);


--
-- TOC entry 5154 (class 1259 OID 160521)
-- Name: redeemer_data_tx_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redeemer_data_tx_id_idx ON public.redeemer_data USING btree (tx_id);


--
-- TOC entry 4965 (class 1259 OID 160519)
-- Name: redeemer_redeemer_data_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX redeemer_redeemer_data_id_idx ON public.redeemer USING btree (redeemer_data_id);


--
-- TOC entry 5149 (class 1259 OID 160522)
-- Name: reference_tx_in_tx_out_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reference_tx_in_tx_out_id_idx ON public.reference_tx_in USING btree (tx_out_id);


--
-- TOC entry 4949 (class 1259 OID 160517)
-- Name: tx_out_inline_datum_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tx_out_inline_datum_id_idx ON public.tx_out USING btree (inline_datum_id);


--
-- TOC entry 4952 (class 1259 OID 160518)
-- Name: tx_out_reference_script_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tx_out_reference_script_id_idx ON public.tx_out USING btree (reference_script_id);


--
-- TOC entry 4990 (class 1259 OID 213033)
-- Name: unique_ada_pots; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_ada_pots ON public.ada_pots USING btree (block_id);


--
-- TOC entry 4978 (class 1259 OID 213034)
-- Name: unique_col_txin; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_col_txin ON public.collateral_tx_in USING btree (tx_in_id, tx_out_id, tx_out_index);


--
-- TOC entry 5144 (class 1259 OID 213035)
-- Name: unique_col_txout; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_col_txout ON public.collateral_tx_out USING btree (tx_id, index);


--
-- TOC entry 5034 (class 1259 OID 213036)
-- Name: unique_delegation; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_delegation ON public.delegation USING btree (tx_id, cert_index);


--
-- TOC entry 5107 (class 1259 OID 213037)
-- Name: unique_epoch_param; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_epoch_param ON public.epoch_param USING btree (epoch_no, block_id);


--
-- TOC entry 5081 (class 1259 OID 213038)
-- Name: unique_ma_tx_mint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_ma_tx_mint ON public.ma_tx_mint USING btree (ident, tx_id);


--
-- TOC entry 5087 (class 1259 OID 213039)
-- Name: unique_ma_tx_out; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_ma_tx_out ON public.ma_tx_out USING btree (ident, tx_out_id DESC);


--
-- TOC entry 5102 (class 1259 OID 213040)
-- Name: unique_param_proposal; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_param_proposal ON public.param_proposal USING btree (key, registered_tx_id);


--
-- TOC entry 5006 (class 1259 OID 213041)
-- Name: unique_pool_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_pool_owner ON public.pool_owner USING btree (addr_id, pool_update_id);


--
-- TOC entry 5015 (class 1259 OID 213042)
-- Name: unique_pool_relay; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_pool_relay ON public.pool_relay USING btree (update_id, ipv4, ipv6, dns_name);


--
-- TOC entry 5011 (class 1259 OID 213043)
-- Name: unique_pool_retiring; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_pool_retiring ON public.pool_retire USING btree (announced_tx_id, cert_index);


--
-- TOC entry 5002 (class 1259 OID 213044)
-- Name: unique_pool_update; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_pool_update ON public.pool_update USING btree (registered_tx_id, cert_index);


--
-- TOC entry 5072 (class 1259 OID 213045)
-- Name: unique_pot_transfer; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_pot_transfer ON public.pot_transfer USING btree (tx_id, cert_index);


--
-- TOC entry 4966 (class 1259 OID 213046)
-- Name: unique_redeemer; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_redeemer ON public.redeemer USING btree (tx_id, purpose, index);


--
-- TOC entry 5150 (class 1259 OID 213047)
-- Name: unique_ref_tx_in; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_ref_tx_in ON public.reference_tx_in USING btree (tx_in_id, tx_out_id, tx_out_index);


--
-- TOC entry 5069 (class 1259 OID 213048)
-- Name: unique_reserves; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_reserves ON public.reserve USING btree (addr_id, tx_id, cert_index);


--
-- TOC entry 5026 (class 1259 OID 213049)
-- Name: unique_stake_deregistration; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_stake_deregistration ON public.stake_deregistration USING btree (tx_id, cert_index);


--
-- TOC entry 5020 (class 1259 OID 213050)
-- Name: unique_stake_registration; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_stake_registration ON public.stake_registration USING btree (tx_id, cert_index);


--
-- TOC entry 5064 (class 1259 OID 213051)
-- Name: unique_treasury; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_treasury ON public.treasury USING btree (addr_id, tx_id, cert_index);


--
-- TOC entry 5038 (class 1259 OID 213052)
-- Name: unique_tx_metadata; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_tx_metadata ON public.tx_metadata USING btree (key, tx_id);


--
-- TOC entry 5049 (class 1259 OID 213053)
-- Name: unique_withdrawal; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_withdrawal ON public.withdrawal USING btree (addr_id, tx_id);


--
-- TOC entry 5245 (class 2620 OID 425774)
-- Name: epoch pool_info_retire_status_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER pool_info_retire_status_trigger AFTER INSERT ON public.epoch FOR EACH ROW EXECUTE FUNCTION koios.pool_info_retire_status();


--
-- TOC entry 5248 (class 2620 OID 425773)
-- Name: pool_retire pool_info_retire_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER pool_info_retire_update_trigger AFTER INSERT OR DELETE ON public.pool_retire FOR EACH ROW EXECUTE FUNCTION koios.pool_info_retire_update();


--
-- TOC entry 5247 (class 2620 OID 425772)
-- Name: pool_owner pool_info_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER pool_info_update_trigger AFTER INSERT ON public.pool_owner FOR EACH ROW EXECUTE FUNCTION koios.pool_info_update();


--
-- TOC entry 5249 (class 2620 OID 425771)
-- Name: pool_relay pool_info_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER pool_info_update_trigger AFTER INSERT ON public.pool_relay FOR EACH ROW EXECUTE FUNCTION koios.pool_info_update();


--
-- TOC entry 5246 (class 2620 OID 425770)
-- Name: pool_update pool_info_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER pool_info_update_trigger AFTER INSERT OR DELETE ON public.pool_update FOR EACH ROW EXECUTE FUNCTION koios.pool_info_update();


--
-- TOC entry 5244 (class 2606 OID 179755)
-- Name: committee_member committee_member_committee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.committee_member
    ADD CONSTRAINT committee_member_committee_id_fkey FOREIGN KEY (committee_id) REFERENCES public.committee(id) ON UPDATE RESTRICT ON DELETE CASCADE;


-- Completed on 2025-06-27 14:10:45 UTC

--
-- PostgreSQL database dump complete
--



-- Koios Artifacts

/* Indexes additional to vanila dbsync instance */
CREATE UNIQUE INDEX IF NOT EXISTS unique_ada_pots ON public.ada_pots USING btree (block_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_col_txin ON public.collateral_tx_in USING btree (tx_in_id, tx_out_id, tx_out_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_col_txout ON public.collateral_tx_out USING btree (tx_id, index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_delegation ON public.delegation USING btree (tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_epoch_param ON public.epoch_param USING btree (epoch_no, block_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_ma_tx_mint ON public.ma_tx_mint USING btree (ident, tx_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_ma_tx_out ON public.ma_tx_out USING btree (ident, tx_out_id DESC);
CREATE UNIQUE INDEX IF NOT EXISTS unique_param_proposal ON public.param_proposal USING btree (key, registered_tx_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_pool_owner ON public.pool_owner USING btree (addr_id, pool_update_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_pool_relay ON public.pool_relay USING btree (update_id, ipv4, ipv6, dns_name);
CREATE UNIQUE INDEX IF NOT EXISTS unique_pool_retiring ON public.pool_retire USING btree (announced_tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_pool_update ON public.pool_update USING btree (registered_tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_pot_transfer ON public.pot_transfer USING btree (tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_redeemer ON public.redeemer USING btree (tx_id, purpose, index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_ref_tx_in ON reference_tx_in USING btree (tx_in_id, tx_out_id, tx_out_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_reserves ON public.reserve USING btree (addr_id, tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_stake_deregistration ON public.stake_deregistration USING btree (tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_stake_registration ON public.stake_registration USING btree (tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_treasury ON public.treasury USING btree (addr_id, tx_id, cert_index);
CREATE UNIQUE INDEX IF NOT EXISTS unique_tx_metadata ON public.tx_metadata USING btree (key, tx_id);
CREATE UNIQUE INDEX IF NOT EXISTS unique_withdrawal ON public.withdrawal USING btree (addr_id, tx_id);
CREATE INDEX IF NOT EXISTS idx_ma_tx_out_ident ON ma_tx_out (ident) INCLUDE (tx_out_id, quantity);
CREATE INDEX IF NOT EXISTS idx_collateral_tx_in_tx_in_id ON collateral_tx_in (tx_in_id);
CREATE INDEX IF NOT EXISTS idx_reference_tx_in_tx_in_id ON reference_tx_in (tx_in_id);

CREATE INDEX IF NOT EXISTS pool_stat_pool_hash_id ON pool_stat (pool_hash_id);
CREATE INDEX IF NOT EXISTS pool_stat_epoch_no ON pool_stat (epoch_no);
CREATE INDEX IF NOT EXISTS idx_reward_rest_addr_id ON reward_rest (addr_id);
CREATE INDEX IF NOT EXISTS idx_reward_rest_spendable_epoch ON reward_rest (spendable_epoch);

CREATE INDEX IF NOT EXISTS idx_stake_address_hash_raw ON stake_address (hash_raw);
CREATE INDEX IF NOT EXISTS idx_drep_hash_raw ON drep_hash (raw);

CREATE INDEX IF NOT EXISTS idx_address_address ON address USING hash (address);
CREATE INDEX IF NOT EXISTS idx_tx_out_stake_address_id ON tx_out (stake_address_id);
-- CREATE INDEX IF NOT EXISTS idx_tx_out_address_id ON tx_out (address_id);
CREATE INDEX IF NOT EXISTS idx_address_stake_address_id ON address (stake_address_id);
CREATE INDEX IF NOT EXISTS idx_voting_procedure_tx_id ON voting_procedure (tx_id DESC);
CREATE INDEX IF NOT EXISTS idx_voting_procedure_voting_anchor_id ON voting_procedure (voting_anchor_id);

-- Blockfrost

CREATE INDEX IF NOT EXISTS bf_idx_block_hash_encoded ON block USING HASH (encode(hash, 'hex'));
CREATE INDEX IF NOT EXISTS bf_idx_datum_hash ON datum USING HASH (encode(hash, 'hex'));
CREATE INDEX IF NOT EXISTS bf_idx_multi_asset_policy ON multi_asset USING HASH (encode(policy, 'hex'));
CREATE INDEX IF NOT EXISTS bf_idx_multi_asset_policy_name ON multi_asset USING HASH ((encode(policy, 'hex') || encode(name, 'hex')));
CREATE INDEX IF NOT EXISTS bf_idx_pool_hash_view ON pool_hash USING HASH (view);
CREATE INDEX IF NOT EXISTS bf_idx_redeemer_data_hash ON redeemer_data USING HASH (encode(hash, 'hex'));
CREATE INDEX IF NOT EXISTS bf_idx_scripts_hash ON script USING HASH (encode(hash, 'hex'));
CREATE INDEX IF NOT EXISTS bf_idx_tx_hash ON tx USING HASH (encode(hash, 'hex'));
CREATE UNIQUE INDEX IF NOT EXISTS bf_u_idx_epoch_stake_epoch_and_id ON epoch_stake (epoch_no, id);
CREATE INDEX IF NOT EXISTS bf_idx_reference_tx_in_tx_in_id ON reference_tx_in (tx_in_id);
CREATE INDEX IF NOT EXISTS bf_idx_collateral_tx_in_tx_in_id ON collateral_tx_in (tx_in_id);
CREATE INDEX IF NOT EXISTS bf_idx_redeemer_script_hash ON redeemer USING HASH (encode(script_hash, 'hex'));
CREATE INDEX IF NOT EXISTS bf_idx_redeemer_tx_id ON redeemer USING btree (tx_id);
CREATE INDEX IF NOT EXISTS bf_idx_col_tx_out ON collateral_tx_out USING btree (tx_id);
CREATE INDEX IF NOT EXISTS bf_idx_ma_tx_mint_ident ON ma_tx_mint USING btree (ident);
CREATE INDEX IF NOT EXISTS bf_idx_ma_tx_out_ident ON ma_tx_out USING btree (ident);
CREATE INDEX IF NOT EXISTS bf_idx_reward_rest_addr_id ON reward_rest USING btree (addr_id);
CREATE INDEX IF NOT EXISTS bf_idx_reward_rest_spendable_epoch ON reward_rest USING btree (spendable_epoch);
CREATE INDEX IF NOT EXISTS bf_idx_drep_hash_raw ON drep_hash USING hash (raw);
CREATE INDEX IF NOT EXISTS bf_idx_drep_hash_view ON drep_hash USING hash (view);
CREATE INDEX IF NOT EXISTS bf_idx_drep_hash_has_script ON drep_hash USING hash (has_script);
CREATE INDEX IF NOT EXISTS bf_idx_delegation_vote_addr_id ON delegation_vote USING hash (addr_id);
