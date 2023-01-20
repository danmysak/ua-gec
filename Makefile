.PHONY: install stats postprocess


postprocess:
	rm -rf data/gec-*/test/source*
	rm -rf data/gec-*/test/target*
	rm -rf data/gec-*/train/source*
	rm -rf data/gec-*/train/target*
	./scripts/postprocess_dataset.py --annotation-layer gec-fluency --path ./data
	./scripts/postprocess_dataset.py --annotation-layer gec-only --path ./data
	bash -c './scripts/normalize_trailing_newslines.py data/gec-{only,fluency}/{test,train}/*/*{.txt,.ann}'

m2:
	./scripts/make_m2.py --partition test --layer gec-fluency --output data/gec-fluency/test/gec-fluency.test.m2 --path ./data
	./scripts/make_m2.py --partition test --layer gec-only --output data/gec-only/test/gec-only.test.m2 --path ./data
	./scripts/make_m2.py --partition train --layer gec-fluency --output data/gec-fluency/train/gec-fluency.train.m2 --path ./data
	./scripts/make_m2.py --partition train --layer gec-only --output data/gec-only/train/gec-only.train.m2 --path ./data

stats:
	./python/ua_gec/stats.py all gec-fluency --path ./data | tee stats.gec-fluency.txt
	./python/ua_gec/stats.py all gec-only --path ./data | tee stats.gec-only.txt

install:
	cd python/ua_gec && ln -sf ../../data data
	cd python && python3 setup.py develop
