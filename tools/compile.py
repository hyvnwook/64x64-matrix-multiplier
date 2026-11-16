"""Compile the archived source sets without mixing duplicate module definitions."""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--modelsim-bin', type=Path, required=True)
    args = parser.parse_args()
    suffix = '.exe' if os.name == 'nt' else ''
    vlib = args.modelsim_bin.resolve() / ('vlib' + suffix)
    vlog = args.modelsim_bin.resolve() / ('vlog' + suffix)
    for tool in (vlib, vlog):
        if not tool.is_file():
            parser.error('Tool not found: ' + str(tool))
    targets = {
        'simulation': sorted((ROOT / 'sim/models').glob('*.v')) + sorted((ROOT / 'rtl').glob('*.v')) + sorted((ROOT / 'sim').glob('*.v')),
        'synthesis': sorted((ROOT / 'synth').glob('*.v')),
    }
    build = ROOT / 'build'
    build.mkdir(exist_ok=True)
    failed = []
    for name, files in targets.items():
        library = build / name
        if not library.exists():
            subprocess.run([str(vlib), str(library)], check=True, cwd=build)
        result = subprocess.run([str(vlog), '-work', str(library), *map(str, files)], cwd=build, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        (build / (name + '.log')).write_bytes(result.stdout)
        if result.returncode:
            failed.append(name)
            print(result.stdout.decode(errors='replace'))
        print(('FAIL' if result.returncode else 'PASS') + ': ' + name + ' (' + str(len(files)) + ' source files)')
    if failed:
        raise SystemExit(1)
    print('Compile checks only; no simulation or synthesis was run.')

if __name__ == '__main__':
    main()
