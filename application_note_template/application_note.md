---
title: "High-Quality Whole Exome Sequencing on Element Biosciences Aviti"
subtitle: "From Coverage to Clinical Insights"
author: "VIB · Nucleomics Core"
date: "February 2026"
---

# Abstract

Whole exome sequencing (WES) has become the gold standard for identifying protein-coding variants in research and clinical genomics. This application note presents a case study evaluating the data quality and analytical capabilities of the Element Biosciences Aviti sequencing platform using the publicly available DVT-0336 dataset from Element Biosciences. This dataset comprises 24 human samples captured with the Twist Human Exome v2.0.2 panel (37 Mb target) and achieves uniform high-depth coverage (mean 50.5×) with outstanding capture efficiency (98.77% of genes with complete coverage). The VIB Nucleomics Core bioinformatics pipeline, applied to this public dataset, identified 28,856 high-quality on-target variants, including 724 HIGH-impact variants (stop-gained, frameshift, and splice-site mutations). Comprehensive quality control analyses revealed minimal target dropout (0.31% of regions) and excellent coverage uniformity across all samples. Beyond standard variant calling, WES data enables advanced genomic analyses including copy number variation (CNV) detection, structural variant identification, gene fusion discovery, and viral integration mapping. The VIB Nucleomics Core offers full-service WES from library preparation through variant annotation, including multi-stage quality control and functional impact annotation.

**Keywords**: Whole exome sequencing, Element Biosciences Aviti, variant calling, DeepVariant, capture efficiency, clinical genomics

---

# 1. Introduction

## 1.1 Whole Exome Sequencing in Genomic Medicine

Whole exome sequencing (WES) targets the ~1-2% of the human genome that encodes proteins, yet captures approximately 85% of disease-causing variants [1]. This cost-effective approach has become indispensable for:

- **Rare disease diagnosis**: Identifying causal mutations in Mendelian disorders
- **Cancer genomics**: Detecting somatic mutations driving tumor development
- **Population genetics**: Large-scale variant discovery in cohort studies
- **Pharmacogenomics**: Characterizing genetic variants affecting drug response

As sequencing costs have declined, WES has transitioned from research tool to clinical diagnostic assay, with stringent quality requirements for coverage depth, uniformity, and variant calling accuracy.

## 1.2 Technical Challenges in Exome Sequencing

High-quality exome sequencing demands:

- **Uniform coverage depth**: Adequate read depth (typically 30-100×) across all target regions to confidently call heterozygous variants
- **Comprehensive capture**: Minimal dropout of target exons, particularly in clinically relevant genes
- **High base quality**: Accurate base calling to reduce false-positive variant calls
- **Efficient data processing**: Robust bioinformatics pipelines optimized for exome data

Capture-based enrichment introduces technical variability, with GC-rich regions, repetitive sequences, and suboptimal probe performance contributing to uneven coverage and gene dropout.

## 1.3 WES at the Nucleomics Core

The VIB Nucleomics Core offers end-to-end WES services:

- **Sequencing**: Element Biosciences Aviti platform (PE150)
- **Capture**: Twist Exome v2.0.2 (37 Mb, 283,942 regions)
- **Bioinformatics**: BWA-MEM2, DeepVariant, GLnexus, SnpEff
- **QC reporting**: MultiQC dashboards and custom summaries at every stage
- **Consultation**: Experimental design, interpretation, and custom analysis support

This application note evaluates data quality and analytical capabilities using the publicly available DVT-0336 dataset (24 human samples sequenced by Element Biosciences).

---

# 2. Materials and Methods

## 2.1 Sample Preparation and Sequencing

The DVT-0336 public dataset from Element Biosciences comprises 24 human genomic DNA samples processed using the **Twist Human Exome v2.0.2** capture panel, targeting:

- **37 Mb of sequence** covering 283,942 target regions
- **20,094 protein-coding genes** (RefSeq annotations)
- **Optimized probe design** for GRCh38 reference genome
- **Exons plus flanking regions** (±20 bp) to capture splice sites

Libraries were sequenced by Element Biosciences on the **Aviti** platform targeting 50-100× mean coverage on-target. The Element Biosciences Aviti system delivers:

- High base quality (>80% bases ≥Q30)
- Low error rates enabling confident variant calling
- Cost-effective high-throughput sequencing
- Rapid turnaround time

### 2.1.1 Open Dataset

Raw sequencing data used in this study is publicly available as dataset **DVT-0336** from Element Biosciences:

> **[Human Whole-Exome Sequencing, Twist for Element Trinity, Exome 2.0 + Comp Spike, Fast Hyb Workflow (Trinity™)](https://www.elementbiosciences.com/resources/human-whole-exome-sequencing-twist-for-element-trinity-exome-2-0-comp-spike-fast-hyb-workflow-trinity)**

- **Run QC report**: [DVT-0336_QC.html](https://element-public-data.s3.us-west-2.amazonaws.com/20241204-Trinity/twist_fast/DVT-0336/DVT-0336_QC.html)
- **FASTQ files**: 24 paired-end samples available at `https://element-public-data.s3.us-west-2.amazonaws.com/20241204-Trinity/twist_fast/DVT-0336/Samples/`
- **Capture panel BED file**: [hg38_exome_comp_spikein_v2.0.2_targets_sorted.re_annotated.bed](https://element-public-data.s3.us-west-2.amazonaws.com/20241204-Trinity/bed/twist/hg38_exome_comp_spikein_v2.0.2_targets_sorted.re_annotated.bed)

### 2.1.2 Sequencing Run QC

Run quality metrics for DVT-0336 confirm excellent data quality. Full interactive QC report: [DVT-0336_QC.html](https://element-public-data.s3.us-west-2.amazonaws.com/20241204-Trinity/twist_fast/DVT-0336/DVT-0336_QC.html).

*Table 1: Run-level sequencing metrics for DVT-0336 (2 lanes, PE150).*

| Metric | Value |
|--------|-------|
| Read length | 150 + 150 bp (PE150, 2 lanes) |
| Polonies | 942,276,900 |
| Assigned yield | 263.7 Gb |
| Index assignment rate | 96.7% |
| Q30 (overall) | 92.8% |

*Table 2: Per-read base quality metrics for DVT-0336.*

| Metric | R1 | R2 |
|--------|----|----|
| Mean Q score | 43.5 | 39.8 |
| % bases ≥Q30 | 95.2% | 90.5% |
| % bases ≥Q40 | 87.2% | 74.0% |

The asymmetry between R1 and R2 is expected for paired-end sequencing: R2 quality is characteristically lower due to accumulation of phasing errors over the second sequencing cycle, yet Q30 >90% for both reads ensures high-confidence variant calling.

**Per-sample sequencing depth.** The 24 samples carry between 25.0 M and 48.0 M read pairs (mean 38.0 M, median 37.6 M), corresponding to **202–390× on-target depth** (mean 308×, 37 Mb exome target). WGS-equivalent depth ranges from 2.3× to 4.5× (mean 3.6×), reflecting the 86-fold enrichment achieved by exome capture. For the bioinformatics benchmarking presented in this report, reads were downsampled to approximately **50× input depth** (based on the 37 Mb target size) for ease and speed of processing; the full-depth data are available in the public DVT-0336 dataset.

*Table 3: Per-sample sequencing depth summary for DVT-0336 (n=24 samples). Depth computed as: read pairs × 2 × 150 bp / 37 Mb exome target (on-target) or / 3.2 Gb genome (WGS equiv).*

| Statistic | Read pairs (M) | Bases (Gb) | On-target depth (×) | WGS equiv (×) |
|-----------|---------------:|----------:|--------------------:|--------------:|
| Min | 25.0 | 7.5 | 202 | 2.3 |
| Max | 48.0 | 14.4 | 390 | 4.5 |
| Mean | 38.0 | 11.4 | 308 | 3.6 |
| Median | 37.6 | 11.3 | 305 | 3.5 |

## 2.2 Bioinformatics Pipeline

The analysis pipeline integrates best-practice tools with multi-stage quality control:

1. **Read QC and filtering** (fastp, FastQC) — adapter trimming and quality filtering (Phred ≥30); produces clean reads for alignment.
2. **Alignment** (BWA-MEM2) — short-read mapping to GRCh38; output BAM files.
3. **Duplicate marking** (GATK Picard) — flags PCR and optical duplicates to prevent coverage inflation and variant calling bias.
4. **Variant calling** (Google DeepVariant) — deep-learning-based SNP and indel detection per sample; gVCF output.
5. **Joint genotyping** (GLnexus) — cohort-level re-genotyping across all 24 samples to improve accuracy and distinguish rare variants from sequencing noise; multi-genome VCF output.
6. **Variant annotation** (SnpEff) — functional impact prediction (gene, transcript, protein change, HIGH/MODERATE/LOW/MODIFIER classification).
7. **Quality filtering** — hard filters (QUAL ≥20, AQ ≥20) to remove low-confidence calls.
8. **On-target filtering** (bcftools) — restricts the variant set to the 283,942 capture target regions; off-target calls resulting from cross-capture from other genomic loci are discarded as they are not part of the exome.
9. **Coverage analysis** (mosdepth) — per-base depth across all target regions; identifies low-coverage exome loci where variant detection may be impaired.
10. **Capture efficiency assessment** — gene- and exon-level dropout analysis; consistently uncaptured regions are documented for clinical reporting.
11. **Sample comparisons** (bcftools isec) — variant intersection and difference sets across sample groups for genotype studies and HIGH-impact variant prioritization.

All steps produce standardized reports aggregated using **MultiQC v1.33**.

## 2.3 Quality Control Metrics

Stringent QC thresholds ensure data integrity:

- **Read quality**: Mean Phred quality ≥30 after filtering
- **Alignment**: Mapping rate ≥95%, properly paired reads ≥90%
- **Coverage depth**: Mean ≥30×, with <10% of target regions below 20× coverage
- **Coverage uniformity**: Median coverage within 20% of mean coverage
- **Variant quality**: QUAL ≥20, allele quality (AQ) ≥20
- **Capture efficiency**: <1% of target regions with complete dropout (0× coverage)

Samples failing QC thresholds are flagged for resequencing or alternative analysis strategies.

---

# 3. Results

## 3.1 Sequencing Quality and Read Processing

All 24 samples passed initial quality control. Read-level QC metrics demonstrated:

- **High base quality**: >85% of bases with Phred quality ≥30 after filtering
- **Consistent read yield**: Uniform read depth across samples after downsampling to target coverage
- **Minimal adapter contamination**: <1% adapter sequences detected
- **Low duplicate rates**: Unlike observed duplication levels in targeted sequencing applications (typically 20-40% depending on library complexity and PCR involvement)

FastQC analysis confirmed no systematic quality issues (per-base quality drops, GC bias anomalies, or overrepresented sequences), indicating high-quality sequencing data suitable for downstream analysis.

## 3.2 Alignment and Coverage Performance

### Coverage Depth and Uniformity

Alignment to GRCh38 yielded outstanding coverage metrics across all 24 samples (Table 4, Figures 1–4):

- **Mean coverage: 50.5× (range 40.0-51.5×)**
- **Median coverage: 50.6×** (tightly matching mean, indicating excellent uniformity)
- **Coverage below 20×: 5.2% of target regions** (median across samples)
- **Coverage above 500×: 0%** (no excessive coverage artifacts)
- **Standard deviation: 18.1×** (low variability across target regions)

### Table 4: Coverage Statistics Summary (Selected Samples)

| Sample | Mean Cov | Median Cov | SD | % Below 20× | % Above 500× |
|--------|----------|------------|-----|-------------|--------------|
| WES_hs_49 | 50.8× | 51.1× | 18.8× | 4.9% | 0% |
| WES_hs_51 | 51.1× | 51.6× | 19.1× | 5.2% | 0% |
| WES_hs_55 | 45.9× | 46.1× | 17.0× | 6.3% | 0% |
| WES_hs_57 | 44.6× | 44.9× | 16.3× | 6.5% | 0% |
| WES_hs_62 | 40.1× | 40.2× | 15.2× | 9.4% | 0% |
| WES_hs_75 | 51.5× | 52.0× | 19.5× | 5.5% | 0% |
| **Cohort Mean** | **50.5×** | **50.6×** | **18.1×** | **5.2%** | **0%** |

*Full dataset: n=24 samples. Coverage calculated across 283,942 target regions (37 Mb).*

### Coverage Distribution

Coverage analysis revealed exceptional uniformity (Figures 1–4):

- **Tight distribution** centered at 50× (Figure 1), with minimal low-coverage outliers
- **Consistent performance** across all samples (Figure 2), demonstrating reproducible capture efficiency
- **>90% of target regions** above 30× coverage (Figure 3), providing statistical power for heterozygous variant detection
- **Uniform coverage across chromosomes** (Figure 4), all samples are female with diploid chrX content.

These metrics meet or exceed recommended standards for clinical exome sequencing [2], ensuring confident variant calling across the capture target.

![](figures/coverage_distribution.png){width=60%}

**Figure 1: Coverage depth distribution** — Histogram of per-region depth across all 24 samples. The narrow peak centred at 50× reflects high coverage uniformity; low-coverage outliers are minimal.

![](figures/coverage_boxplot.png){width=60%}

**Figure 2: Coverage consistency across samples** — Per-sample coverage boxplots. All 24 samples cluster tightly around 50× with narrow interquartile ranges, confirming reproducible capture and no outlier samples requiring re-sequencing.

![](figures/cumulative_coverage.png){width=60%}

**Figure 3: Cumulative coverage across target regions** — Fraction of target bases reaching at least X depth. At the 30× threshold (vertical line), ~93% of regions are covered; only ~5% fall below 20×, the practical minimum for confident heterozygous variant detection.

![](figures/coverage_by_chromosome.png){width=60%}

**Figure 4: Mean coverage by chromosome** — Mean depth per autosome is uniform; reduced X and Y coverage reflects the all-female composition of the cohort (expected biological absence of Y, hemizygous X), not a technical artefact.

---

## 3.3 Capture Efficiency and Gene Coverage

### Outstanding Capture Performance

Capture efficiency analysis revealed exceptional performance of the Twist Exome v2.0.2 panel:

- **98.77% of genes (19,846/20,094) achieved complete exon coverage**
- **Only 0.31% of target regions (871/283,942) consistently uncaptured** (0× coverage in ≥20 samples)
- **0.79% of regions (2,246) with poor coverage** (<10× in ≥18 samples)
- **Minimal dropout: 0.08 Mb uncaptured, 0.17 Mb poor coverage** (total <0.7% of target)

### Gene-Level Analysis

Gene-level capture assessment (Figures 5-7) identified:

- **19,846 genes with complete coverage**: All exons captured with adequate depth
- **237 genes with partial exon loss**: One or more exons dropped out or poorly covered
- **11 genes with complete exon loss**: All exons failed capture (likely absent from panel design for 4 of them)

The majority of uncaptured genes are Y-chromosome genes (CDY1, SRY, TSPY family, DAZ1-4, RPS4Y1/2, KDM5D, USP9Y, UTY, ZFY, and others), biologically absent in this all-female cohort. Among the 11 completely lost genes, 7 are Y-linked; among the 237 partially lost genes, approximately 30 are Y-linked. The true technical dropout rate is therefore lower than the raw statistics suggest.

The remaining genes with partial exon loss represent candidates for targeted Sanger sequencing validation or alternative assay design (e.g., long-range PCR, targeted amplicon sequencing). These genes typically include known difficult-to-capture loci (GC-rich regions, repetitive elements, segmental duplications) and genes at panel design boundaries.

![](figures/capture_funnel.png){width=60%}

**Figure 5: Capture efficiency funnel** — Of 2.67M exons targeted by the Twist panel, 2.662M (>99.8%) were successfully captured. Only 4,568 targeted exons (0.17%) failed capture despite probe coverage.

![](figures/gene_loss.png){width=60%}

**Figure 6: Gene-level exon loss distribution** — 19,846 genes (98.77%) show zero exon dropout. The 248 genes with partial or complete loss are predominantly attributable to Y-chromosome biology (see above) or known difficult-to-capture loci (high GC content, repetitive elements, pseudogenes) — a limitation shared across all hybridisation-based capture platforms.

![](figures/top_genes.png){width=60%}

**Figure 7: Top 20 genes by exon dropout** — Ranked by fraction of exons lost across all samples. Red markers indicate complete loss (all exons), blue indicates partial loss. Seven of the eleven completely lost genes are Y-linked (CDY1, CDY1B, CDY2A, CDY2B, RPS4Y2, SRY, TSPY9), consistent with biological absence in the female cohort. Genes remaining on this list after excluding Y-linked loci represent candidates for targeted follow-up (PCR, amplicon sequencing) where complete exome coverage is required.

### Biological Interpretation

The outstanding capture efficiency (98.77% complete gene coverage) ensures:

- **Comprehensive variant detection** across the vast majority of protein-coding genes
- **Confident negative calls**: Absence of variants in well-covered genes is reliable
- **Minimal blind spots**: Only 248 genes require alternative approaches
- **Clinical applicability**: Performance meets standards for diagnostic exome sequencing

Consistently uncaptured regions are documented and reported, enabling informed interpretation of negative findings and guiding targeted follow-up as needed.

---

## 3.4 Variant Detection and Annotation

### High-Confidence Variant Calling

Variant calling used DeepVariant per sample, followed by GLnexus joint genotyping across all 24 samples to improve genotype accuracy through cohort-level evidence.

**Variant Calling Results:**

- **552,407 total variants** called genome-wide across all samples
- **100% pass rate** for quality filters (QUAL ≥20, AQ ≥20)
- **28,856 on-target variants** within the 283,942 capture target regions
  - 27,539 SNPs (95.4%)
  - 1,346 INDELs (4.6%)
  - 71 other variant types (<1%)

### On-Target vs. Total Variants

The 94.8% of calls outside the on-target set originate from off-target capture: hybridisation enriches primarily for the 37 Mb target but also pulls down flanking genomic sequence at lower, uneven depth. These off-target regions are not part of the exome and unsuitable for confident variant interpretation and are excluded from downstream analysis. The 28,856 on-target variants represent calls in well-covered protein-coding exons — the regions where disease-relevant variants are most likely and where coverage is sufficient for reliable genotyping.

### Table 5: Variant Filtering Cascade

| Filtering Stage | Total Variants | SNPs | INDELs |
|-----------------|----------------|------|--------|
| **Total Variants** | 552,407 | 485,229 | 67,757 |
| **Hard Filtered** (QUAL ≥20, AQ ≥20) | 552,407 (100%) | 485,229 | 67,757 |
| **On-Target** (within capture BED) | 28,856 (5.2%) | 27,539 | 1,346 |

*100% pass rate for quality filters indicates high initial call quality from DeepVariant/GLnexus.*

![](figures/filtering_cascade.png){width=60%}

**Figure 8: Variant filtering cascade** — 552,407 variants called genome-wide; all pass hard quality filters (100% rate, left/middle bars). On-target filtering retains 28,856 variants (5.2%) within the capture target regions (right bar, SNPs in blue, INDELs in orange). The large reduction reflects off-target reads rather than quality failures.

### Functional Annotation with SnpEff

Comprehensive variant annotation using SnpEff v5.1 (GRCh38.105 database) predicted functional impacts across 164,006 variant effects:

### Table 6: Variant Annotation Summary

| Category | Type | Count | Percent |
|----------|------|-------|---------|
| **Impact Level** | HIGH | 724 | 0.44% |
| | MODERATE | 29,788 | 18.16% |
| | LOW | 38,365 | 23.39% |
| | MODIFIER | 95,129 | 58.00% |
| **Functional Class** | Missense | 28,920 | 44.39% |
| (Coding variants) | Nonsense | 171 | 0.26% |
| | Silent | 36,058 | 55.35% |
| **Key Variant Types** | Frameshift | 343 | 0.21% |
| | Splice acceptor | 85 | 0.05% |
| | Splice donor | 52 | 0.03% |
| | Splice region | 3,489 | 2.08% |
| | Stop gained | 176 | 0.11% |
| | Stop lost | 32 | 0.02% |

*Missense/Silent ratio: 0.80 (within expected range for human exomes).*

![](figures/impact_distribution.png){width=60%}

**Figure 9: Variant impact distribution (SnpEff)** — Pie chart of predicted functional impact across all annotated variants. HIGH (0.44%, 724 variants): loss-of-function mutations (stop-gained, frameshift, splice-site disruption). MODERATE (18.2%, 29,788): missense and in-frame indels. LOW (23.4%, 38,365): synonymous and other likely-neutral changes. MODIFIER (58.0%, 95,129): intronic, UTR, and intergenic variants. The HIGH/MODIFIER ratio is consistent with population-scale exome studies.

![](figures/functional_classes.png){width=60%}

**Figure 10: Coding variant functional classes** — Bar chart of coding variants by functional consequence. Missense (44.4%, 28,920 variants), Silent/synonymous (55.3%, 36,058), Nonsense (0.26%, 171). Missense/Silent ratio = 0.80, within the expected range for natural human variation [3]. Nonsense and high-impact missense variants are candidates for downstream prioritization using pathogenicity predictors (SIFT, PolyPhen-2, CADD) and clinical databases (ClinVar, OMIM).

### Biological Interpretation

The 724 HIGH-impact variants represent prime candidates for functional validation:

- **176 stop-gained (nonsense) variants**: Introduce premature termination codons, likely causing loss-of-function
- **343 frameshift variants**: Insertions/deletions disrupting reading frame, typically resulting in truncated proteins
- **85 splice-acceptor + 52 splice-donor variants**: Disrupt canonical splice sites, causing aberrant splicing

The 28,920 missense variants require additional prioritization using:

- **Pathogenicity prediction** (SIFT, PolyPhen-2, CADD scores)
- **Conservation analysis** (PhyloP, GERP scores)
- **Clinical databases** (ClinVar, OMIM, HGMD)
- **Gene-disease associations** (OMIM, Orphanet)

The balanced missense/silent ratio (0.80) indicates absence of systematic annotation artifacts and is consistent with population-scale exome studies [3].

---

## 3.5 Sample and Genotype Comparisons

### Flexible Comparative Analysis Framework

The pipeline supports diverse experimental designs through configurable sample comparisons:

- **Genotype contrasts**: Identify variants distinguishing wild-type from knockout, mutant, or disease samples
- **Tissue comparisons**: Detect tissue-specific somatic variants indicating mosaicism or clonal architecture
- **Case-control studies**: Compare variant burden between affected and unaffected individuals / groups
- **Family analysis**: Trace inheritance patterns across pedigrees

The automated comparison workflow uses **bcftools isec** to partition variants into:

- **Group-specific variants**: Present in one group but (almost #) absent in the other
- **Shared variants**: Common to both groups
- **HIGH-impact prioritization**: Automatic filtering for functionally critical variants (stop-gained, frameshift, splice-site)

(#) to allow for one or few wrongly labelled sample(s)

### Example Use Cases

**Genotype Analysis** (Wild-Type vs. Knockout):
- Identifies variants unique to KO samples, potentially including the engineered mutation plus off-target variants
- Highlights background genetic differences between strains

**Tissue Mosaicism Analysis**:
- Detects somatic variants present in one tissue but not others from the same individual
- Relevant for cancer evolution studies, clonal hematopoiesis, or developmental mosaicism
- will require deeper sequencing than for mendelian variants which are expected haploid or diploid by nature

**Case-Control Burden Testing**:
- Compares rare variant burden between affected cases and healthy controls
- Identifies genes or pathways enriched for variants in disease cohorts

All comparison results include annotated variant lists, HIGH-impact variant summaries, and statistical breakdowns, facilitating rapid identification of biologically relevant differences.

---

# 4. Advanced Applications and Future Directions

Beyond standard variant calling, WES data supports diverse downstream analyses expanding the scope of genomic discovery:

## 4.1 Copy Number Variation (CNV) Detection

Exome sequencing enables detection of gene-level copy number alterations through coverage-based approaches:

- **Tools**: GATK CNV pipeline, ExomeDepth, CODEX2
- **Resolution**: Exon-level CNVs (deletions, duplications)
- **Applications**:
  - Cancer genomics: Oncogene amplifications (ERBB2, MYC), tumor suppressor deletions (CDKN2A, PTEN)
  - Constitutional CNVs: Rare disease diagnostics (microdeletion/microduplication syndromes)
  - Structural variation: Large-scale genomic rearrangements

While WES CNV detection has lower resolution than array CGH or WGS, it effectively identifies clinically relevant gene-dosage alterations without additional experiments.

## 4.2 Structural Variant (SV) Detection

Large-scale rearrangements can be inferred from discordant read pairs and split reads:

- **Tools**: Manta, DELLY, Lumpy, GRIDSS
- **Detectable SVs**: Deletions, duplications, inversions, translocations
- **Limitations**: Breakpoint resolution limited to captured exons; intronic breakpoints may be missed
- **Applications**: Fusion genes in cancer, complex rearrangements in rare diseases

WES provides complementary SV information to whole-genome sequencing, particularly for coding-region rearrangements.

## 4.3 Gene Fusions and Rearrangements

Chromosomal translocations generating fusion genes are detectable at the DNA level:

- **Tools**: FusionCatcher (adapted for DNA), STAR-Fusion (RNA-seq complement)
- **Applications**:
  - Cancer diagnostics: BCR-ABL1 (chronic myeloid leukemia), EML4-ALK (non-small cell lung cancer)
  - Targeted therapy selection: Fusion-driven cancers responsive to kinase inhibitors
- **Validation strategy**: WES DNA-level evidence combined with RNA-seq fusion transcript detection

## 4.4 Viral Integration Detection

Exome data can identify viral sequences integrated into the human genome:

- **Tools**: VirusSeq, ViFi, VirusFinder
- **Detectable viruses**: HPV (cervical cancer), HBV/HCV (hepatocellular carcinoma), EBV (lymphomas)
- **Applications**:
  - Cancer etiology: Virus-driven oncogenesis
  - Personalized therapy: Viral antigen targeting in immunotherapy
- **Approach**: Unmapped reads aligned to viral genomes, followed by integration breakpoint identification

## 4.5 Mitochondrial Variant Calling

The high read depth of exome sequencing captures mitochondrial DNA (mtDNA):

- **Tools**: MToolBox, mitoCaller, GATK Mutect2 (mitochondrial mode)
- **Analysis**: Heteroplasmy quantification (variant allele frequency across cells)
- **Applications**:
  - Mitochondrial disorders (MELAS, MERRF, Leigh syndrome)
  - Aging studies (mtDNA mutation accumulation)
  - Forensic genetics (maternal lineage tracing)

## 4.6 Customized Downstream Analysis

WES variant calls integrate with diverse bioinformatics workflows:

- **Pathway enrichment**: KEGG, Reactome, Gene Ontology analysis to identify affected biological processes
- **Variant burden testing**: SKAT, SKAT-O for rare variant association analysis in case-control cohorts
- **Polygenic risk scores**: Integration with GWAS data for complex disease risk prediction
- **Clinical variant interpretation**: Automated classification using ACMG/AMP guidelines and ClinVar/OMIM databases

The Nucleomics Core provides consultation on advanced analysis design and can implement custom workflows tailored to specific research questions.

---

# 5. Discussion and Summary

## 5.1 Data Quality

This case study demonstrates that the Element Biosciences Aviti platform performs well for whole exome sequencing:

- **Uniform coverage** (mean 50.5×) supports confident heterozygous variant detection
- **High capture efficiency** (98.77% complete gene coverage, 0.31% target dropout)
- **High variant quality** (100% pass rate for hard filters)

These metrics meet standards for clinical diagnostic exomes [2].

## 5.2 Bioinformatics Pipeline

The Nucleomics Core can run an end-to-end WES pipeline: BWA-MEM2 alignment, DeepVariant variant calling, GLnexus joint genotyping, and SnpEff annotation. QC is assessed at every stage and aggregated with MultiQC. Workflows are version-controlled and follow GATK Best Practices [4].

## 5.3 Flexible Experimental Designs

The pipeline supports diverse study designs:

- **Small pilot studies** (n=5-10 samples) to proof-of-concept studies
- **Medium cohorts** (n=50-100 samples) for disease gene discovery
- **Large population studies** (n=1000+ samples) at shallow levels for rare variant association testing, only limited by the barcoding capabilities of the method.

Custom sample comparison frameworks enable:

- Genotype contrasts (WT vs. mutant)
- Tissue profiling (multi-tissue sampling from individuals)
- Case-control designs (affected vs. unaffected)
- Family studies (parent-offspring trios, extended pedigrees) allowing haplotyping and phasing by descendence

## 5.4 Biological Insights

This study identified:

- **28,856 high-quality on-target variants** across 24 human samples
- **724 HIGH-impact variants** prioritizing functional follow-up (stop-gained, frameshift, splice-site)
- **237 genes with partial exon loss**, primarily Y-chromosome genes (expected biological absence in female-only cohort) with remaining genes guiding targeted validation strategies
- **Comprehensive annotation** linking variants to genes, transcripts, and predicted functional impacts

These results provide a foundation for:

- **Disease gene discovery**: Identifying causal variants in rare diseases
- **Genotype-phenotype studies**: Correlating genetic variation with traits
- **Population genetics**: Characterizing allele frequency spectra
- **Functional validation**: Prioritizing variants for CRISPR, expression studies, or biochemical assays

## 5.5 Service Offering at VIB Nucleomics Core

The Nucleomics Core provides full-service WES, from library preparation through variant annotation. Project scopes range from small pilots to large cohorts.

**Note:** The deliverable is a catalog of high quality variants, it will require further inspection, filtering, and validation in order to identify causative variants.

**Available services:**

- Library preparation (Twist Exome capture) and sequencing (Element Biosciences Aviti)
- Standard bioinformatics: alignment, variant calling, joint genotyping, annotation, QC reporting (done at the Core)
- Advanced analyses: CNV, SV, gene fusions, viral integration, mitochondrial variants (done by the customer)
- Custom workflows: pathway enrichment, variant burden testing, ACMG/AMP classification (done by the customer)
- Consultation on experimental design, sample size, and interpretation

**Supported designs:** pilot studies, cohort sequencing, rare disease diagnostics, tumor-normal paired analysis. Human and mouse exomes supported; other species require capture panels which may or not be available from Twist.

### **Contact Information**

For project consultation, pricing, or additional information:

**VIB Nucleomics Core**
Email: nucleomics@vib.be
Web: https://www.nucleomics.be

---

# 6. Key Metrics Summary

<div style="border: 3px solid #4472C4; padding: 20px; background-color: #F0F4F8; margin: 20px 0;">

## **WES Performance on Element Biosciences Aviti**

### **Platform & Capture**
- **Sequencing**: Element Biosciences Aviti
- **Samples**: 24 human exomes
- **Capture**: Twist Exome v2.0.2 (37 Mb, 283,942 regions)

### **Coverage Excellence**

- **Mean coverage: 50.5×**
- **Coverage uniformity: 5.2% below 20× (median)**
- **Gene capture: 98.77% complete**
- **Target dropout: 0.31%**

### **Variant Discovery**

- **On-target variants: 28,856**
- **HIGH-impact variants: 724**
- **Quality pass rate: 100%**

### **Advanced Analyses Available**

- Copy number variation (CNV) detection
- Structural variant identification
- Gene fusion discovery
- Viral integration mapping
- Mitochondrial variant calling
- Pathway enrichment & burden testing

</div>

---

# 7. References

1. Bamshad MJ, Ng SB, Bigham AW, et al. Exome sequencing as a tool for Mendelian disease gene discovery. *Nat Rev Genet*. 2011;12(11):745-755. doi:10.1038/nrg3031

2. Sims D, Sudbery I, Ilott NE, et al. Sequencing depth and coverage: key considerations in genomic analyses. *Nat Rev Genet*. 2014;15(2):121-132. doi:10.1038/nrg3642

3. 1000 Genomes Project Consortium. A global reference for human genetic variation. *Nature*. 2015;526(7571):68-74. doi:10.1038/nature15393

4. Van der Auwera GA, Carneiro MO, Hartl C, et al. From FastQ data to high-confidence variant calls: the Genome Analysis Toolkit best practices pipeline. *Curr Protoc Bioinformatics*. 2013;43:11.10.1-11.10.33. doi:10.1002/0471250953.bi1110s43

5. Poplin R, Chang PC, Alexander D, et al. A universal SNP and small-indel variant caller using deep neural networks. *Nat Biotechnol*. 2018;36(10):983-987. doi:10.1038/nbt.4235

6. Yun T, Li H, Chang PC, et al. Accurate, scalable cohort variant calls using DeepVariant and GLnexus. *Bioinformatics*. 2021;36(24):5582-5589. doi:10.1093/bioinformatics/btaa1081

7. Cingolani P, Platts A, Wang LL, et al. A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff. *Fly (Austin)*. 2012;6(2):80-92. doi:10.4161/fly.19695

8. Plagnol V, Curtis J, Epstein M, et al. A robust model for read count data in exome sequencing experiments and implications for copy number variant calling. *Bioinformatics*. 2012;28(21):2747-2754. doi:10.1093/bioinformatics/bts526

9. Layer RM, Chiang C, Quinlan AR, Hall IM. LUMPY: a probabilistic framework for structural variant discovery. *Genome Biol*. 2014;15(6):R84. doi:10.1186/gb-2014-15-6-r84

10. Chen Y, Yao H, Thompson EJ, et al. VirusSeq: software to identify viruses and their integration sites using next-generation sequencing of human cancer tissue. *Bioinformatics*. 2013;29(2):266-267. doi:10.1093/bioinformatics/bts665

11. Twist Bioscience. Twist Human Core Exome Plus Kit Technical Note. San Francisco, CA: Twist Bioscience; 2024.

12. Element Biosciences. Element AVITI System: High-Quality Sequencing Chemistry White Paper. San Diego, CA: Element Biosciences; 2024.

13. Li H. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. *arXiv*. 2013;1303.3997. https://arxiv.org/abs/1303.3997

14. Vasimuddin M, Misra S, Li H, Aluru S. Efficient architecture-aware acceleration of BWA-MEM for multicore systems. *IEEE Parallel and Distributed Processing Symposium (IPDPS)*. 2019. doi:10.1109/IPDPS.2019.00041

15. Richards S, Aziz N, Bale S, et al. Standards and guidelines for the interpretation of sequence variants: a joint consensus recommendation of the American College of Medical Genetics and Genomics and the Association for Molecular Pathology. *Genet Med*. 2015;17(5):405-424. doi:10.1038/gim.2015.30

---

## Appendix — Glossary of Technical Terms

**BAM file**
Binary Alignment Map — the compressed binary file storing all reads after they have been aligned to the reference genome, used for variant calling and coverage analysis.

**bcftools**
A suite of command-line tools for reading, writing, filtering, and comparing VCF and BCF variant files.

**bcftools isec**
A bcftools subcommand that finds the intersection or complement between variant files — used here to identify variants unique to one sample group or shared between groups.

**BED file**
A tab-delimited text file that specifies genomic regions as chromosome, start position, and end position. Used here to define the 283,942 exome capture target intervals.

**BWA-MEM2**
Burrows-Wheeler Aligner Maximal Exact Matches version 2 — an ultrafast short-read aligner used to map sequencing reads to the GRCh38 reference genome.

**CNV (Copy Number Variation)**
A genomic alteration in which a segment of DNA is present in more or fewer copies than the reference — for example, a deletion (0–1 copies) or duplication (3+ copies) of a gene.

**DeepVariant**
A variant caller developed by Google that applies a deep convolutional neural network to sequencing data to identify SNPs and INDELs with high accuracy.

**Diploid / haploid**
Diploid means having two copies of each chromosome (one from each parent), as in most human somatic cells. Haploid means having a single copy, as with the Y chromosome or the mitochondrial genome. Heterozygous variants appear at ~50% allele frequency in diploid tissue; hemizygous variants at ~100%.

**Downsampling**
Randomly reducing the number of sequencing reads to a fixed depth — used here to normalise all 24 samples to ~50× for consistent analysis, since the original data contains up to 390× on-target depth.

**Duplication rate (PCR duplicates)**
The fraction of sequencing reads identified as copies of the same original DNA molecule, introduced by PCR amplification during library preparation. High duplication rates inflate coverage estimates and reduce effective sequencing depth.

**DVT-0336**
A public benchmark dataset released by Element Biosciences, containing whole-exome sequencing data from 24 human samples sequenced on the Aviti platform using the Trinity chemistry and Twist Human Exome v2.0.2 capture panel.

**Element Biosciences Aviti**
A benchtop next-generation sequencing platform from Element Biosciences that uses avidity sequencing chemistry — in which many labelled nucleotide analogues bind cooperatively — to achieve high base accuracy and low error rates.

**Exon**
The protein-coding portion of a gene that is retained in mature messenger RNA after the non-coding introns are removed by splicing. Whole exome sequencing targets all exons across the genome.

**fastp**
An all-in-one preprocessing tool for sequencing reads that performs adapter trimming, quality filtering, and QC report generation in a single fast pass.

**FastQC**
A quality control tool that produces per-sample HTML reports summarising base quality scores, GC content, duplication levels, and adapter contamination in raw sequencing files.

**Frameshift variant**
An insertion or deletion of a number of bases not divisible by three, shifting the reading frame of the gene and typically disrupting the entire downstream protein sequence.

**GATK (Genome Analysis Toolkit)**
A widely used software framework from the Broad Institute for discovering variants in high-throughput sequencing data, with documented "Best Practices" workflows for germline and somatic variant calling.

**GC-rich regions**
Genomic regions with a high proportion of guanine and cytosine bases. These regions tend to form stable secondary structures that reduce capture efficiency and PCR amplification, resulting in lower and less uniform coverage.

**Gene fusion**
A hybrid gene formed when two previously separate genes are joined by a chromosomal rearrangement. Fusions can produce aberrant proteins that drive cancer, for example BCR-ABL1 in chronic myeloid leukaemia or EML4-ALK in lung cancer.

**GLnexus**
A scalable joint-genotyping tool that merges individual-sample gVCF files from DeepVariant into a single multi-sample VCF, improving genotype accuracy especially for rare variants.

**GRCh38**
Genome Reference Consortium Human Build 38 — the current standard human reference genome assembly, also known as hg38. All alignments and annotations in this study use GRCh38.

**gVCF (genomic VCF)**
A variant of the standard VCF format that records genotype information for every position in the genome — not only variant sites — enabling accurate joint genotyping across many samples later.

**Hard filters**
Fixed numerical thresholds applied to variant quality metrics to discard low-confidence calls. Used here: QUAL ≥20 and allele quality (AQ) ≥20. These replace the machine-learning VQSR approach when cohort size is insufficient for VQSR training.

**Heteroplasmy**
The presence of more than one mitochondrial DNA sequence within a cell or individual, expressed as the fraction of mutant copies among all mitochondrial genomes. Low-level heteroplasmy requires deep sequencing to detect reliably.

**HIGH / MODERATE / LOW / MODIFIER impact (SnpEff)**
SnpEff's four-tier classification of predicted variant effect: HIGH = likely loss-of-function (frameshift, stop-gained, splice-site disruption); MODERATE = likely functional change (missense, in-frame indel); LOW = probably neutral (synonymous, splice-region); MODIFIER = non-coding or distant regulatory effect (intronic, UTR, upstream/downstream).

**Hybridisation capture**
The library enrichment step where biotinylated RNA or DNA probes are mixed with fragmented genomic DNA; probes bind complementary target sequences, which are then pulled down with streptavidin beads and sequenced preferentially.

**INDEL**
An insertion or deletion of one or more bases in the DNA sequence. INDELs are the second most common class of genetic variant after SNPs and are particularly challenging to call accurately.

**Joint genotyping**
Calling variants simultaneously across all samples in a cohort rather than independently, so that information from every sample informs the genotype of each. This improves sensitivity for low-frequency variants and reduces false positives.

**Library complexity**
The number of distinct DNA molecules in a sequencing library before amplification. Low complexity leads to high PCR duplication rates and reduced effective coverage, even with many raw reads.

**Missense variant**
A single nucleotide change that substitutes one amino acid for a different one in the encoded protein. Missense variants may be benign, disease-causing, or of uncertain significance depending on the position and the change.

**mosdepth**
A fast and efficient tool for computing per-base and per-region sequencing depth from aligned BAM files, used here for exon-level coverage assessment.

**mtDNA (mitochondrial DNA)**
The small circular genome within mitochondria, present in hundreds to thousands of copies per cell and inherited exclusively through the maternal line. Pathogenic mtDNA variants cause a range of metabolic disorders.

**MultiQC**
A tool that aggregates QC output from many different bioinformatics tools into a single interactive HTML dashboard, enabling rapid quality assessment across all samples.

**Nonsense variant (stop-gained)**
A point mutation that converts a coding codon into a stop codon, causing premature termination of translation and typically producing a truncated, non-functional protein.

**Oncogene / tumor suppressor**
An oncogene promotes cell growth and division when mutated or amplified; a tumor suppressor restrains cell division and must be inactivated (both copies) to promote cancer. WES detects both point mutations and copy number changes in these genes.

**On-target filtering / on-target rate**
Restriction of variant calls to positions within the defined capture target BED file. The on-target rate here (5.2%) reflects off-target capture from flanking sequences, which are not part of the exome and are excluded from interpretation.

**Paired-end sequencing (PE150)**
A sequencing strategy in which both ends of each DNA fragment are independently read. PE150 denotes 150 bp from each end, yielding up to 300 bp of sequence per fragment and improving alignment accuracy for indels and repetitive regions.

**Pathway enrichment**
A statistical analysis testing whether a set of genes (e.g., those carrying rare variants in disease patients) is significantly over-represented in a biological pathway or functional category compared to chance.

**Phred quality score (Q score)**
A logarithmic measure of sequencing base call accuracy: Q30 = 1 error per 1,000 bases (99.9% accuracy); Q40 = 1 per 10,000 (99.99%). Q30 is the standard minimum threshold for reliable variant calling.

**Picard MarkDuplicates**
A Broad Institute tool that identifies PCR duplicate reads in a BAM file based on identical alignment start and end positions, flagging them so variant callers can exclude them from analysis.

**Polonies**
Sequencing clusters on the Aviti flow cell, each grown from a single library molecule by local amplification. The total number of polonies determines the raw data throughput of a run.

**RefSeq**
The NCBI Reference Sequence database — a curated set of annotated reference sequences for genes, transcripts, and proteins. Used here to define the 20,094 protein-coding genes in the exome target.

**SnpEff**
A tool for annotating genetic variants with their predicted functional consequences on genes and transcripts, assigning them to impact categories (HIGH, MODERATE, LOW, MODIFIER) and reporting the specific molecular effect (e.g., missense, frameshift, splice-site).

**SNP (Single Nucleotide Polymorphism)**
A single-base change at a specific genomic position, the most common class of genetic variant in humans. SNPs may be benign population polymorphisms or pathogenic mutations depending on their location and effect.

**Somatic variants**
Variants acquired by a cell during its lifetime — through DNA replication errors, mutagen exposure, or repair failures — rather than inherited from parents. Somatic variants are the primary driver of cancer.

**Splice donor / splice acceptor / splice region variants**
Splice donor (GT at the 5' exon boundary) and splice acceptor (AG at the 3' exon boundary) are the conserved dinucleotides that direct the splicing machinery. Variants at these exact positions (HIGH impact) cause exon skipping or intron retention. Splice region variants lie nearby and may have milder splicing effects (LOW impact).

**Structural Variant (SV)**
A large-scale genomic rearrangement — typically >50 bp — including deletions, duplications, inversions, and translocations. SVs can disrupt gene function, dosage, or regulation.

**Synonymous (silent) variant**
A nucleotide substitution that changes a codon but not the encoded amino acid, due to redundancy in the genetic code. Generally considered functionally neutral, though some synonymous variants affect splicing or mRNA stability.

**Target dropout**
Failure to achieve adequate sequencing coverage over a specific capture target region, leaving variants in that region undetectable. Measured here as regions with 0× depth in ≥20 of 24 samples; 0.31% of the 37 Mb target.

**Tissue mosaicism**
The presence of two or more genetically distinct cell populations within the same individual, arising from a somatic mutation after fertilisation. Mosaic variants are present at sub-diploid allele frequencies and require deeper sequencing to detect reliably.

**Tumor-normal pairs**
Matched sequencing of a patient's tumour tissue and their normal (germline) tissue. Comparing the two allows somatic (cancer-specific) variants to be distinguished from inherited germline variants.

**Twist Human Exome v2.0.2**
A hybridisation capture kit from Twist Bioscience that targets 37 Mb of the human exome across 283,942 genomic regions, including all exons ±20 bp flanking sequence to capture splice sites.

**UTR (Untranslated Region)**
The portions of a gene transcript flanking the coding sequence — 5' UTR upstream and 3' UTR downstream — that are transcribed but not translated. Variants in UTRs may affect mRNA stability, translation efficiency, or microRNA binding and are classified as MODIFIER impact by SnpEff.

**Variant burden testing**
A statistical analysis comparing the total count or frequency of (usually rare) variants in a gene or region between two groups — for example, patients versus healthy controls — to identify genes enriched for potentially causative variants.

**VCF (Variant Call Format)**
The standard tab-delimited text format for storing genetic variants and their per-sample genotype calls, widely used throughout bioinformatics pipelines.

**WES (Whole Exome Sequencing)**
A sequencing strategy that enriches and sequences only the protein-coding exons of the genome — approximately 1–2% of total DNA. WES captures the majority of known disease-causing variants at substantially lower cost than whole-genome sequencing.

**WGS-equivalent depth**
The theoretical coverage depth that would result if the same number of reads were spread uniformly across the entire 3.2 Gb genome rather than concentrated on the 37 Mb exome target. Used here to express how much raw data was generated relative to a whole-genome experiment.

**Y-chromosome genes**
Genes located on the Y chromosome, present only in biological males (XY). In a female (XX) cohort, failure to capture Y-linked genes is an expected biological finding — not a sequencing or capture failure.

---

## Acknowledgements

This document was written by Stéphane Plaisance (Nucleomics Core) with the assistance of Claude (Anthropic), an AI language model, for drafting, editing, and literature review.

*Document version: 1.0 (Technical Report)*
*Last updated: march 10, 2026*
