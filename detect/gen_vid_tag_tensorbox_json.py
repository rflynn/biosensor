'''
convert ../vid-tag/$tag/*.xml
given a set of images and annotations in ../vid-tag/$tag/...
    use the annotations to produce JSON for consumption by tensorbox
'''

'''
$ head tensorbox/data/brainwash/train_boxes.json
[
  {
    "image_path": "brainwash_10_27_2014_images/00000000_640x480.png",
    "rects": [
      {
        "x1": 152.0,
        "x2": 167.0,
        "y1": 115.0,
        "y2": 135.0
      },
'''

import os
import sys

from PIL import Image
import xml.etree.ElementTree as ET



def process_annotation_file(filepath, tagmatch, cwd):
    tree = ET.parse(filepath)
    root = tree.getroot()
    imgpath = root.find('./path').text
    relimgpath = os.path.relpath(imgpath, cwd)
    filename = root.find('./filename').text
    ext = imgpath[imgpath.rindex('.') + 1:]
    objs = root.findall('./object')
    rects = []
    for n, obj in enumerate(objs):
        tag = obj.find('./name').text
        if tag == tagmatch:
            coords = {o.tag: int(o.text) for o in obj.find('./bndbox').getchildren()}
            rects.append({
                'x1': coords['xmin'],
                'x2': coords['xmax'],
                'y1': coords['ymin'],
                'y2': coords['ymax'],
            })
    return {
        'image_path': relimgpath,
        'rects': rects
    }


def do_process_annotation_file(filepath, tagmatch, cwd):
    try:
        return process_annotation_file(filepath, tagmatch, cwd)
    except Exception as e:
        sys.stderr.write(filepath + '\n')
        raise e


def each_annotation(tagdir):
    for d, subdirs, _files in os.walk('../vid-tag/' + tagdir):
        # process most-recently modified subdirs first...
        for subdir in subdirs:
            path = d + '/' + subdir
            sys.stderr.write('scanning {}\n'.format(path))
            if not subdir.startswith('_'):
                for d2, subdirs2, files in os.walk(path):
                    # print(d2, subdirs2, files)
                    for f in files:
                        if f.endswith('.xml'):
                            yield d2 + '/' + f


def process_annotations(tagdir, tagmatch, cwd):
    l = []
    for filepath in each_annotation(tagdir):
        x = do_process_annotation_file(filepath, tagmatch, cwd)
        if x:
            l.append(x)
    return l

def test_process_annotation():
    cropped_path = '../vid-tag-cropped'
    dirpath = '../vid-tag/cardinalis-cardinalis'
    xmlfile = '2016-10-17-16-51-03.xml'
    filepath = dirpath + '/' + xmlfile
    process_annotation_file(filepath)


def all_tags():
    return [d for d in list(os.walk('../vid-tag'))[0][1] if not d.startswith('_')]


if __name__ == '__main__':
    import json
    cwd = os.getcwd()
    tagdir = sys.argv[1]
    tagmatch = tagdir
    print(json.dumps(process_annotations(tagdir, tagmatch, cwd), sort_keys=True, indent=4))
