#!/usr/bin/env cwlrunner

class: Workflow

cwlVersion: v1.0

inputs:
  - id: input
    type: File
    doc: "to be hashed all the ways"
  - id: lftp_out_conf
    type: File

outputs:
  - id: output
    type: File
    outputSource: unify/output

steps:
  - id: md5
    run: hashsplitter-md5.cwl.yml
    in:
      - { id: input, source: input }
    out:
      - { id: output }

  - id: sha
    run: hashsplitter-sha.cwl.yml
    in:
      - { id: input, source: input }
    out:
      - { id: output }

  - id: whirlpool
    run: hashsplitter-whirlpool.cwl.yml
    in:
      - { id: input, source: input }
    out:
      - { id: output }

  - id: unify
    run: hashsplitter-unify.cwl.yml
    in:
      - { id: md5, source: md5/output }
      - { id: sha, source: sha/output }
      - { id: whirlpool, source: whirlpool/output }
    out:
      - { id: output }

  - id: encrypt
    run: hashsplitter-unify.encrypt.yml
    in:
      - id: files_to_encrypt
        source:
          - md5/output
          - sha/output
          - whirlpool/output
    out:
      - { id: encrypted }
