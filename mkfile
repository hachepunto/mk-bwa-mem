<config.mk

## Align whit BWA MEM
results/%.unpaired.sam:	data/%.unpaired.fastq.gz 
	mkdir -p `dirname $target`
	bwa mem \
		-t $PROCESSORS \
		$REFERENCE \
		$prereq \
		> $target".build" \
	&& mv $target".build" $target

results/%.paired.sam:	data/%_R1.paired.fastq.gz data/%_R2.paired.fastq.gz
	mkdir -p `dirname $target`
	bwa mem \
		-t $PROCESSORS \
		$REFERENCE \
		$prereq \
		> $target".build" \
	&& mv $target".build" $target

##Sam to bam conversion
results/%.bam:	results/%.sam
	samtools view \
		-b \
		-S $prereq > $target".build" \
	&& mv $target".build" $target \
	&& rm $prereq

##Ordering BAMs by chromosome coordinate
results/%.sorted.bam:	results/%.bam
	picard-tools SortSam \
		I=$prereq \
		O=$target".build" \
		SO=coordinate \
	&& mv $target".build" $target \
	&& rm $prereq

## Samtools index BAM 
results/%.sorted.bam.bai:D:	results/%.sorted.bam
	mkdir -p `dirname $target`
	samtools index \
		-@ $PROCESSORS \
		-b $prereq
